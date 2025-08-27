package infrastructure

import (
	"context"
	"fmt"
	"log"
	"os"
	domain "sema/Domain"
	"strings"

	"google.golang.org/genai"
)

type AI struct {
	model_name string
	Ai_client  *genai.Client
	config     *genai.GenerateContentConfig
}

func InitAIClient() *AI {
	ctx := context.Background()
	apiKey := os.Getenv("GEMINI_API_KEY")
	if apiKey == "" {
		log.Fatal("API key not found!")
	}
	client, err := genai.NewClient(ctx, &genai.ClientConfig{
		APIKey: apiKey,
	})
	if err != nil {
		log.Fatal(err)
	}

	config := &genai.GenerateContentConfig{
		SystemInstruction: genai.NewContentFromText(`
	You are a supportive wellbeing assistant. 
	Your job is to assemble JSON action cards for users. 

	Rules:
	- Always return valid JSON (no markdown, no prose).
	- Use ONLY the provided steps and miniTools — do not invent new ones.
	- Each card must include: title, description, steps[], miniTools[], ifWorse, disclaimer.
	- Keep the tone empathetic and safe.
	- Translate into the requested language if specified.
	- If context is high-risk, always include the disclaimer and ifWorse guidance.

	Output must strictly follow the given JSON schema.
`, genai.RoleUser),
	}

	model_name := os.Getenv("GEMINI_MODEL")

	return &AI{
		model_name: model_name,
		config:     config,
		Ai_client:  client,
	}
}

func (ai *AI) GenerateActionCard(actionBlock *domain.ActionBlock) (*string, error) {
	ctx := context.Background()

	// Convert slices to a formatted string for the prompt
	stepsList := ""
	for _, s := range actionBlock.Block.MicroSteps {
		stepsList += fmt.Sprintf("- %s\n", s)
	}

	toolsList := ""
	for _, t := range actionBlock.Block.ToolLinks {
		toolsList += fmt.Sprintf("- title : %s, url: %s\n", t.Title, t.URL)
	}

	userPrompt := genai.Text(fmt.Sprintf(`
	Generate a JSON action card for the topic "%s".
	- Language: %s
	- Use ONLY the provided steps and miniTools below.
	- Keep title and description short.
	- Always include "ifWorse" and "disclaimer".
	- Return JSON ONLY. No explanations.
	- Use the same language as in the action cards.

	Steps:
	%s

	MiniTools:
	%s

	JSON Structure Example:
	{
		"%s": {
			"title": "Exam Stress Relief",
			"description": "Let's break this down into manageable steps.",
			"steps": [...],
			"miniTools": [...],
			"ifWorse": "If panic sets in, try the grounding exercise or reach out to a trusted friend.",
			"disclaimer": "This is general wellbeing information, not medical or mental health advice."
		}
	}
	`, actionBlock.TopicKey, actionBlock.Language, stepsList, toolsList, actionBlock.TopicKey))

	result, err := ai.Ai_client.Models.GenerateContent(
		ctx,
		ai.model_name,
		userPrompt,
		ai.config,
	)

	if err != nil {
		return nil, err
	}

	resultMessage := result.Text()
	return &resultMessage, nil
}

func (ai *AI) GenerateTopicKey(content string) (string, error) {
	ctx := context.Background()

	userPrompt := genai.Text(fmt.Sprintf(`
	Extract one topic key from the following content that is close to %s:
	1. Study Stress
	2. Money Stress
	3. Family conflict
	4. Workload 
	5. sleep
	6. Motivation
	7. Loneliness
	8. Procrastination
	9. Time management
	10. Exam Panic
	11. New City anxiety
	12. Self confidence
	`, content))

	result, err := ai.Ai_client.Models.GenerateContent(
		ctx,
		ai.model_name,
		userPrompt,
		ai.config,
	)

	if err != nil {
		return "", err
	}

	return result.Text(), nil
}

func (ai *AI) GenerateRiskCheck(content string) (int, []string, error) {
	ctx := context.Background()

	userPrompt := genai.Text(fmt.Sprintf(`
	Analyze the following content for risk factors:
	Please assess the risk level of the following situation. 
    There are three risk levels:

	1. Low Risk
	Definition: A situation that causes minor inconvenience or frustration but is unlikely to result in significant harm, emotional distress, or long-term negative consequences. These are typically everyday annoyances or distractions that can be resolved easily.

	Examples:

	Getting a low grade on a single homework assignment due to a lack of focus.

	Feeling unproductive after spending too much time on social media.

	Minor disagreements with a friend about a movie to watch.

	Losing an item of low value, such as a pen or a hair tie.

	Feeling annoyed by a slow internet connection.

	2. Medium Risk
	Definition: A situation with a possible negative outcome or moderate concern. While not immediately life-threatening, these issues can lead to emotional distress, damage relationships, or have negative impacts on well-being if not addressed.

	Examples:

	Persistent conflict with a family member or friend that is causing emotional strain.

	Feeling overwhelmed with anxiety about a future exam or presentation.

	A significant drop in grades across multiple subjects due to a lack of motivation.

	Experiencing a conflict at work that is affecting your professional performance.

	A difficult argument with a romantic partner.

	3. High Risk
	Definition: A situation that involves serious consequences, requires immediate and urgent attention, and could result in significant harm to oneself or others. This category includes severe threats to physical safety, mental health, or legal well-being.

	Examples:

	Experiencing suicidal ideation or thoughts of self-harm.

	Engaging in or planning to engage in illegal or criminal activities.

	Providing or seeking instructions for harmful or dangerous acts.

	Severe and persistent depression or anxiety that is debilitating.

    Based on this context, what is the risk level for the user's input?
	and generate a list of relevant tags. Those tags can not be empty.
	Give me your response in the format: Risk Level: <1 or 2 or 3>\nTags: tag1, tag2, tag3
	%s
	`, content))

	result, err := ai.Ai_client.Models.GenerateContent(
		ctx,
		ai.model_name,
		userPrompt,
		ai.config,
	)

	if err != nil {
		return 0, nil, err
	}

	var risk int
	var tags []string

	// Parse the result to extract risk and tags
	response := result.Text()
	lines := strings.Split(response, "\n")
	for _, line := range lines {
		line = strings.TrimSpace(line)
		if strings.HasPrefix(line, "Risk Level:") {
			var parsed int
			_, scanErr := fmt.Sscanf(line, "Risk Level: %d", &parsed)
			if scanErr == nil && parsed >= 1 && parsed <= 3 {
				risk = parsed
			}
		}
		if strings.HasPrefix(line, "Tags:") {
			tagsStr := strings.TrimPrefix(line, "Tags:")
			tagsStr = strings.TrimSpace(tagsStr)
			if tagsStr != "" {
				tags = strings.Split(tagsStr, ",")
				for i := range tags {
					tags[i] = strings.TrimSpace(tags[i])
				}
			}
		}
	}

	// Ensure risk is between 1 and 3, default to 1 if not parsed
	if risk < 1 || risk > 3 {
		risk = 1
	}
	// Ensure tags is not nil
	if tags == nil {
		tags = []string{}
	}

	return risk, tags, nil
}

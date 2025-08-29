package infrastructure

import (
	"context"
	"fmt"
	"log"
	"os"
	domain "sema/Domain"
	"strconv"
	"strings"

	"google.golang.org/genai"
)

type AI struct {
	model_name string
	Ai_client  *genai.Client
	config     *genai.GenerateContentConfig
}

func ptrFloat32(f float32) *float32 {
	return &f
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
		Temperature: ptrFloat32(0.0), // Use pointer to float32
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
STRICT INSTRUCTIONS: Analyze the user's content and select exactly ONE topic key from the predefined list below.

USER CONTENT: "%s"

TOPIC KEYS (choose exactly one if related):
- Study Stress
- Money Stress
- Family conflict
- Workload
- Sleep
- Motivation
- Loneliness
- Procrastination
- Time management
- Exam Panic
- New City anxiety
- Self confidence

RULES:
1. You MUST choose exactly one key ONLY if there's a clear match to the user's content
2. If no clear match exists, respond with "topic_key: No related topic found"
3. Your response MUST begin with "topic_key: "
4. Output ONLY the required format: "topic_key: <selected_key>" or "topic_key: No related topic found"
5. DO NOT include any other text, explanations, or conversational phrases
6. DO NOT create new topic keys - use only from the provided list

IMPORTANT: Your entire response should be exactly one line in the specified format.
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
    
    response := result.Text()
    response = strings.ReplaceAll(response, "```json", "")
    response = strings.ReplaceAll(response, "```", "")
    response = strings.TrimSpace(response)

    // Extract the topic key from the response
    if strings.HasPrefix(response, "topic_key: ") {
        return strings.TrimPrefix(response, "topic_key: "), nil
    }
    
    // If the response doesn't start with the expected prefix, check if it's one of the valid keys
    validKeys := []string{
        "Study Stress", "Money Stress", "Family conflict", "Workload", 
        "Sleep", "Motivation", "Loneliness", "Procrastination", 
        "Time management", "Exam Panic", "New City anxiety", "Self confidence",
    }
    
    for _, key := range validKeys {
        if response == key {
            return key, nil
        }
    }
    
    // If response contains "No related topic found" but without the prefix
    if strings.Contains(strings.ToLower(response), "no related topic") {
        return "No related topic found", nil
    }
    
    // If we get an unexpected response, return the error case
    return "No related topic found", nil
}
func (ai *AI) GenerateRiskCheck(content string) (int, []string, error) {
    ctx := context.Background()

    userPrompt := genai.Text(fmt.Sprintf(`
STRICT RISK ASSESSMENT INSTRUCTIONS:

Analyze the following user content for risk factors and provide EXACTLY the requested output format.

USER CONTENT: "%s"

RISK LEVEL DEFINITIONS (choose exactly ONE):

1 - Low Risk: Minor inconvenience or frustration, unlikely to result in significant harm or long-term negative consequences.

2 - Medium Risk: Possible negative outcome or moderate concern that could lead to emotional distress or relationship damage if not addressed.

3 - High Risk: Serious consequences requiring immediate attention, including threats to physical safety, mental health, or legal well-being.

TAGS REQUIREMENT:
- Generate 3-5 relevant tags describing the main themes
- Tags must be concise, lowercase, hyphen-separated (e.g., "academic-stress")
- Tags must reflect the specific content
- Tags cannot be empty

OUTPUT FORMAT RULES:
1. Response MUST begin with "Risk Level: " followed by exactly 1, 2, or 3
2. Next line MUST begin with "Tags: " followed by comma-separated tags
3. NO other text, explanations, or conversational phrases
4. NO markdown formatting
5. NO deviations from this format

EXAMPLE OUTPUT:
Risk Level: 2
Tags: academic-pressure, time-management, exam-anxiety

IMPORTANT: Be consistent. Same content should always produce the same risk level and similar tags.
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

    // Parse the result
    response := result.Text()
    response = strings.ReplaceAll(response, "```", "")
    response = strings.TrimSpace(response)
    
    lines := strings.Split(response, "\n")
    
    for _, line := range lines {
        line = strings.TrimSpace(line)
        
        // Parse risk level
        if strings.HasPrefix(line, "Risk Level:") {
            riskStr := strings.TrimSpace(strings.TrimPrefix(line, "Risk Level:"))
            if parsed, err := strconv.Atoi(riskStr); err == nil && parsed >= 1 && parsed <= 3 {
                risk = parsed
            }
        }
        
        // Parse tags
        if strings.HasPrefix(line, "Tags:") {
            tagsStr := strings.TrimSpace(strings.TrimPrefix(line, "Tags:"))
            if tagsStr != "" {
                rawTags := strings.Split(tagsStr, ",")
                for _, tag := range rawTags {
                    cleanTag := strings.TrimSpace(tag)
                    cleanTag = strings.ToLower(cleanTag)
                    cleanTag = strings.ReplaceAll(cleanTag, " ", "-")
                    if cleanTag != "" {
                        tags = append(tags, cleanTag)
                    }
                }
            }
        }
    }

    // Validation and fallbacks
    if risk < 1 || risk > 3 {
        risk = 1 // Default to low risk if parsing fails
    }
    
    if len(tags) == 0 {
        // Generate fallback tags based on risk level
        switch risk {
        case 1:
            tags = []string{"minor-issue", "everyday-concern", "low-priority"}
        case 2:
            tags = []string{"moderate-concern", "emotional-strain", "needs-attention"}
        case 3:
            tags = []string{"urgent-matter", "serious-concern", "immediate-help-needed"}
        }
    }

    return risk, tags, nil
}
package infrastructure

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"log"
	"os"
	domain "sema/Domain"
	repository "sema/Repository"
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
    1 - Low risk (e.g., minor inconvenience, unlikely to cause harm)
    2 - Medium risk (e.g., possible negative outcome, moderate concern)
    3 - High risk (e.g., serious consequences, urgent attention needed)
    Based on this context, what is the risk level for the user's input?
	and generate a list of relevant tags.
	Give me your response in the format: Risk Level: <number>\nTags: tag1, tag2, tag3
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
	// Example response: "Risk Level: 2\nTags: stress, anxiety, workload"
	lines := strings.Split(response, "\n")
	for _, line := range lines {
		line = strings.TrimSpace(line)
		if strings.HasPrefix(line, "Risk Level:") {
			fmt.Sscanf(line, "Risk Level: %d", &risk)
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

	return risk, tags, nil
}

func (ai *AI) GenerateCrisisCard(region string, tags []string) (*string, error) {
	ctx := context.Background()

	// Read region resources
	fileData, err := os.ReadFile("assets/resources/region.json")
	if err != nil {
		return nil, errors.New("cannot read from file region.json")
	}

	var crisis []repository.CrisisDto
	if err = json.Unmarshal(fileData, &crisis); err != nil {
		return nil, errors.New("invalid json in region.json")
	}

	// Format tags nicely (comma-separated string)
	tagString := strings.Join(tags, ", ")

	var allResources []interface{}
	var allSafetyPlans []interface{}

	for _, c := range crisis {
		allResources = append(allResources, c.Resources)
		allSafetyPlans = append(allSafetyPlans, c.SafteyPlans)
	}

	resourcesJSON, err := json.MarshalIndent(allResources, "", "  ")
	if err != nil {
		return nil, errors.New("failed to marshal all resources")
	}

	safetyPlansJSON, err := json.MarshalIndent(allSafetyPlans, "", "  ")
	if err != nil {
		return nil, errors.New("failed to marshal all safety plans")
	}

	userPrompt := genai.Text(fmt.Sprintf(`
Generate a JSON crisis card for the region "%s".
- Tags (user feelings): %s
- Use the tags to decide which resources and safety plan steps are most relevant.
- Use ONLY the provided resources and safety plan steps below.
- Use the same language as in the crisis cards.
- Return JSON ONLY. No explanations.

Rules:
- "resources" must be tailored to both the region and the tags.
- "safety_plan" must give practical steps based on the tags.
- If multiple tags apply, combine the relevant steps and resources.

Resources:
%s

Safety Plan:
%s

JSON Structure Example:
{
	"region": "%s",
	"resources": [
		{
			"type": "hotline",
			"name": "Ethiopian Lifeline",
			"contact": {
				"phone": "+251-800-123-456",
				"availability": "24/7",
				"website": null,
				"email": null
			}
		},
		{
			"type": "ngo",
			"name": "Mental Health Support Ethiopia",
			"contact": {
				"phone": null,
				"availability": null,
				"website": "https://mhs-et.org",
				"email": "info@mhs-et.org"
			}
		}
	],
	"safety_plan": [
		{ "step": 1, "instruction": "Identify a safe place." },
		{ "step": 2, "instruction": "List 3 trusted contacts." },
		{ "step": 3, "instruction": "Keep emergency numbers nearby." }
	]
}
`, region, tagString, string(resourcesJSON), string(safetyPlansJSON), region))

	// Call AI
	resp, err := ai.Ai_client.Models.GenerateContent(
		ctx,
		ai.model_name,
		userPrompt,
		ai.config,
	)
	if err != nil {
		return nil, err
	}

	resultMessage := resp.Text()
	return &resultMessage, nil
}

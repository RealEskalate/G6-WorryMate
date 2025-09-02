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
	Your job is to generate wellbeing JSON cards for users across different contexts (e.g., action cards, crisis cards).
	General Rules:
	- Always return valid JSON (no markdown, no extra prose).
	- Use the schema provided by the specific method (different card types may have different schemas).
	- Never invent new fields outside of the given schema.
	- Content must always be empathetic, safe, and supportive.
	- If translation is requested, translate all fields into the target language.
	- If the context is high-risk or crisis-related, always include safety disclaimers according to the schema.
	- Keep tone clear, non-judgmental, and kind." 

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
    - The ui tools section is for the frontend to use for displaying appropriate ui elements along with the card.
    - You can use ui tools only if they are in this list : ["box_breathing", "daily_journal", "grounding", "tracker"].
    - always return two relevant ui tools for the topic based on the action block.
    - The mini tools should have the same format as the one in the action block.

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
			"miniTools": [{"title" : "minitool title", "url" : "mini tool title"}, ...],
            "uiTools" : ["box_breathing", "daily_journal"],
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
		var apiErr *genai.APIError

		if errors.As(err, &apiErr) {
			if apiErr.Status == "429" {
				return nil, errors.New("quota/rate limit exceeded, please retry later")
			}
		}
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
- study_stress
- money_stress
- family_conflict
- workload
- sleep
- motivation
- loneliness
- procrastination
- time_management
- exam_panic
- new_city_anxiety
- self_confidence
- other

RULES:
1. You MUST choose exactly one key ONLY if there's a clear match to the user's content
2. If no clear match exists, respond with "topic_key: other"
3. Your response MUST begin with "topic_key: "
4. Output ONLY the required format: "topic_key: <selected_key>" or "topic_key: other"
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

func (ai *AI) GenerateCrisisCard(lang, region string, tags []string) (*string, error) {
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
- Use language "%s".
- Return JSON ONLY. No explanations.

Rules:
- "resources" must be tailored to both the region and the tags.
- "safety_plan" must give practical steps based on the tags.
- If multiple tags apply, combine the relevant steps and resources.
- Don't include tags and langauage in the JSON response.

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
`, region, tagString, lang, string(resourcesJSON), string(safetyPlansJSON), region))

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

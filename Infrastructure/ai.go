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
	"sync" // NEW: Import the sync package for the mutex

	"google.golang.org/genai"
)

// MODIFIED: The AI struct now holds multiple clients and state for round-robin
type AI struct {
	model_name   string
	clients      []*genai.Client // MODIFIED: Changed from a single client to a slice of clients
	config       *genai.GenerateContentConfig
	currentIndex int        // NEW: To track which key to use next
	mu           sync.Mutex // NEW: To make client selection safe for concurrent requests
}

func ptrFloat32(f float32) *float32 {
	return &f
}

// MODIFIED: This function now initializes a pool of clients from multiple API keys
func InitAIClient() *AI {
	ctx := context.Background()
	// MODIFIED: Read a comma-separated list of keys
	apiKeysStr := os.Getenv("GEMINI_API_KEYS")
	if apiKeysStr == "" {
		log.Fatal("GEMINI_API_KEYS environment variable not set or empty!")
	}
	
	apiKeys := strings.Split(apiKeysStr, ",")
	var clients []*genai.Client

	// MODIFIED: Loop through each key and create a client for it
	for _, key := range apiKeys {
		client, err := genai.NewClient(ctx, &genai.ClientConfig{
			APIKey: key,
		})
		if err != nil {
			// Log a warning but don't crash, so the app can run with the valid keys
			log.Printf("Warning: Failed to create client with one of the API keys: %v", err)
			continue
		}
		clients = append(clients, client)
	}

	if len(clients) == 0 {
		log.Fatal("No valid Gemini clients could be initialized. Check your GEMINI_API_KEYS.")
	}

	log.Printf("Successfully initialized %d Gemini clients.", len(clients))

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
		Temperature: ptrFloat32(0.0),
	}

	model_name := os.Getenv("GEMINI_MODEL")

	// MODIFIED: Initialize the new AI struct
	return &AI{
		model_name: model_name,
		config:     config,
		clients:    clients,
		currentIndex: 0,
	}
}

// NEW: Helper method to get the next client in a thread-safe, round-robin fashion
func (ai *AI) getClient() *genai.Client {
	ai.mu.Lock()
	defer ai.mu.Unlock()

	// Get the client at the current index
	client := ai.clients[ai.currentIndex]

	// Move to the next index for the next request, wrapping around if needed
	ai.currentIndex = (ai.currentIndex + 1) % len(ai.clients)

	return client
}

func (ai *AI) GenerateActionCard(actionBlock *domain.ActionBlock) (*string, error) {
	ctx := context.Background()

	// ... (prompt building logic remains exactly the same) ...
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
	- If the topic is other,return the same json format but with only title : "other" (in lower case) and the description the steps in a coherent format and also include the ifWorse and disclaimer always. The other fields should be empty.

	Steps:
	%s

	MiniTools:
	%s

	JSON Structure Example:
	{
		"%s": {
			"title": "Exam Stress Relief",
			"description": "Let's break this down into manageable steps.",
			"steps": [{"title" : "step title", "description" : "step description"}...],
			"miniTools": [{"title" : "minitool title", "url" : "mini tool url"}, ...],
            "uiTools" : ["box_breathing", "daily_journal"],
			"ifWorse": "If panic sets in, try the grounding exercise or reach out to a trusted friend.",
			"disclaimer": "This is general wellbeing information, not medical or mental health advice."
		}
	}
	`, actionBlock.TopicKey, actionBlock.Language, stepsList, toolsList, actionBlock.TopicKey))

	// MODIFIED: Use the getClient() helper to pick a client for this request
	client := ai.getClient()
	// log.Print(client.ClientConfig().APIKey)
	result, err := client.Models.GenerateContent(
		ctx,
		ai.model_name,
		userPrompt,
		ai.config,
	)

	// ... (error handling and result parsing remain exactly the same) ...
	if err != nil {
		// Try to find valid api keys in clients
		count := 0
		for (count < len(ai.clients)) {
			ans, err := ai.GenerateActionCard(actionBlock)
			if (err == nil) {
				return ans, err
			}
			count += 1
		}
		
		var apiErr genai.APIError
		// log.Printf("err concrete type = %T, value = %#v\n", err, err)
		if errors.As(err, &apiErr) {
			// log.Print("err : ", err.Error(), "api err : ", apiErr )
			if apiErr.Code == 429 {
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

	// MODIFIED: Use the getClient() helper to pick a client for this request
	client := ai.getClient()
	result, err := client.Models.GenerateContent(
		ctx,
		ai.model_name,
		userPrompt,
		ai.config,
	)

	if err != nil {
		// Try to find valid api keys in clients
		count := 0
		for (count < len(ai.clients)) {
			ans, err := ai.GenerateTopicKey(content)
			if (err == nil) {
				return ans, err
			}
			count += 1
		}

		var apiErr genai.APIError
		// log.Printf("err concrete type = %T, value = %#v\n", err, err)
		if errors.As(err, &apiErr) {
			// log.Print("err : ", err.Error(), "api err : ", apiErr )
			if apiErr.Code == 429 {
				return "", errors.New("quota/rate limit exceeded, please retry later")
			}
		}
		return "", err
	}

	response := result.Text()
	response = strings.ReplaceAll(response, "```json", "")
	response = strings.ReplaceAll(response, "```", "")
	response = strings.TrimSpace(response)

	if strings.HasPrefix(response, "topic_key: ") {
		return strings.TrimPrefix(response, "topic_key: "), nil
	}

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

	if strings.Contains(strings.ToLower(response), "no related topic") {
		return "No related topic found", nil
	}

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
	// MODIFIED: Use the getClient() helper to pick a client for this request
	client := ai.getClient()
	result, err := client.Models.GenerateContent(
		ctx,
		ai.model_name,
		userPrompt,
		ai.config,
	)


	if err != nil {
		// Try to find valid api keys in clients
		count := 0
		for (count < len(ai.clients)) {
			num, ans, err := ai.GenerateRiskCheck(content)
			if (err == nil) {
				return num, ans, err
			}
			count += 1
		}

		var apiErr genai.APIError
		// log.Printf("err concrete type = %T, value = %#v\n", err, err)
		if errors.As(err, &apiErr) {
			// log.Print("err : ", err.Error(), "api err : ", apiErr )
			if apiErr.Code == 429 {
				return 0, nil, errors.New("quota/rate limit exceeded, please retry later")
			}
		}
		return 0, nil, err
	}

	var risk int
	var tags []string

	response := result.Text()
	response = strings.ReplaceAll(response, "```", "")
	response = strings.TrimSpace(response)

	lines := strings.Split(response, "\n")

	for _, line := range lines {
		line = strings.TrimSpace(line)
		if strings.HasPrefix(line, "Risk Level:") {
			riskStr := strings.TrimSpace(strings.TrimPrefix(line, "Risk Level:"))
			if parsed, err := strconv.Atoi(riskStr); err == nil && parsed >= 1 && parsed <= 3 {
				risk = parsed
			}
		}

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
	client := ai.getClient()
	resp, err := client.Models.GenerateContent(
		ctx,
		ai.model_name,
		userPrompt,
		ai.config,
	)
	if err != nil {
		// Try to find valid api keys in clients
		count := 0
		for (count < len(ai.clients)) {
			ans, err := ai.GenerateCrisisCard(lang, region, tags)
			if (err == nil) {
				return ans, err
			}
			count += 1
		}

		var apiErr genai.APIError
		// log.Printf("err concrete type = %T, value = %#v\n", err, err)
		if errors.As(err, &apiErr) {
			// log.Print("err : ", err.Error(), "api err : ", apiErr )
			if apiErr.Code == 429 {
				return nil, errors.New("quota/rate limit exceeded, please retry later")
			}
		}
		return nil, err
	}

	resultMessage := resp.Text()
	return &resultMessage, nil
}

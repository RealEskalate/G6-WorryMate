package infrastructure

import (
	"context"
	"fmt"
	"log"
	"os"

	"google.golang.org/genai"
)

type AI struct {
	model_name string
	Ai_client  *genai.Client
	config     *genai.GenerateContentConfig
}

func InitAIClient() *AI {
	ctx := context.Background()
	client, err := genai.NewClient(ctx, nil)
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

func (ai *AI) GenerateActionCard(topic string, language string, steps []string, miniTools []string) (*string, error) {
	ctx := context.Background()

	// Convert slices to a formatted string for the prompt
	stepsList := ""
	for _, s := range steps {
		stepsList += fmt.Sprintf("- %s\n", s)
	}

	toolsList := ""
	for _, t := range miniTools {
		toolsList += fmt.Sprintf("- %s\n", t)
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
	`, topic, language, stepsList, toolsList, topic))

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


package controllers

import (
	domain "sema/Domain"
	"time"
)

type ChatDTO struct {
	Message        string    `json:"message"`
	SenderIsAI     bool      `json:"senderisai"`
	TimeOfCreation time.Time `json:"timeofcreation"`
}

type ToolLinkDTO struct {
	Title string `json:"title"`
	URL   string `json:"url"`
}

type BlockDTO struct {
	EmpathyOpeners []string      `json:"empathy_openers"`
	MicroSteps     []string      `json:"micro_steps"`
	Scripts        []string      `json:"scripts"`
	ToolLinks      []ToolLinkDTO `json:"tool_links"`
	IfWorse        []string      `json:"if_worse"`
	Disclaimer     string        `json:"disclaimer"`
}

type ActionBlockDTO struct {
	TopicKey string   `json:"topic_key"`
	Block    BlockDTO `json:"block"`
	Language string   `json:"language"`
}

func ChangeToDomain(dtoObj ActionBlockDTO) *domain.ActionBlock {
	// Convert Action block into domain for returning
	var res = domain.ActionBlock{
		TopicKey: dtoObj.TopicKey,
		Block: domain.Block{
			EmpathyOpeners: dtoObj.Block.EmpathyOpeners,
			MicroSteps:     dtoObj.Block.MicroSteps,
			Scripts:        dtoObj.Block.Scripts,
			IfWorse:        dtoObj.Block.IfWorse,
			Disclaimer:     dtoObj.Block.Disclaimer,
		},
		Language: dtoObj.Language,
	}

	for _, val := range dtoObj.Block.ToolLinks {
		res.Block.ToolLinks = append(res.Block.ToolLinks, domain.ToolLink{
			Title: val.Title,
			URL:   val.URL,
		})
	}
	return &res
}

type Tag struct {
	Tags []string `json:"tags"`
}

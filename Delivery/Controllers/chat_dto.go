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

type ContactDto struct {
	Phone        string `json:"phone"`
	Availability string `json:"availability"`
	Website      string `json:"website"`
	Email        string `json:"email"`
}

type ResourceDto struct {
	Type     string     `json:"type"`
	Name     string     `json:"name"`
	Contacts ContactDto `json:"contact"`
}

type PlansDto struct {
	Step        int    `json:"step"`
	Instruction string `json:"instruction"`
}

type CrisisDto struct {
	Region      string        `json:"region"`
	Resources   []ResourceDto `json:"resources"`
	SafteyPlans []PlansDto    `json:"safety_plan"`
}

func ChangeToChatDTO(ac *domain.ActionBlock) (*ActionBlockDTO) {
	toolLks := []ToolLinkDTO{}
	for _, content := range(ac.Block.ToolLinks) {
		tmp := ToolLinkDTO{
			Title: content.Title,
			URL: content.URL,
		}
		toolLks = append(toolLks, tmp)
	}
	
	block := BlockDTO{
		EmpathyOpeners: ac.Block.EmpathyOpeners,
		MicroSteps: ac.Block.MicroSteps,
		Scripts: ac.Block.Scripts,
		ToolLinks: toolLks,
	}

	return &ActionBlockDTO{
		TopicKey: ac.TopicKey,
		Block: block,
		Language: ac.Language,
	}
}
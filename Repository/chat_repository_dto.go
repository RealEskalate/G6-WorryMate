package repository

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

func ChangeToDomainCrisis(crisisDto CrisisDto) *domain.Crisis {
	var res = domain.Crisis{
		Region:      crisisDto.Region,
		Resources:   []domain.Resource{},
		SafteyPlans: []domain.Plans{},
	}
	for _, p := range crisisDto.SafteyPlans {
		var plan = domain.Plans{
			Step:        p.Step,
			Instruction: p.Instruction,
		}
		res.SafteyPlans = append(res.SafteyPlans, plan)
	}
	for _, value := range crisisDto.Resources {
		var contacts = domain.Contact{
			Phone:        value.Contacts.Phone,
			Email:        value.Contacts.Email,
			Website:      value.Contacts.Website,
			Availability: value.Contacts.Availability,
		}
		var resource = domain.Resource{
			Type:     value.Type,
			Name:     value.Name,
			Contacts: contacts,
		}
		res.Resources = append(res.Resources, resource)
	}
	return &res
}

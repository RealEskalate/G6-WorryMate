package domain

import "time"

type User struct {
	Password string
	Role     string
	Username string
	Email    string
}

type Chat struct {
	Message        string
	SenderIsAI     bool
	TimeOfCreation time.Time
}
type ToolLink struct {
	Title string
	URL   string
}

type Block struct {
	EmpathyOpeners []string
	MicroSteps     []string
	Scripts        []string
	ToolLinks      []ToolLink
	IfWorse        []string
	Disclaimer     string
}

type ActionBlock struct {
	TopicKey string
	Block    Block
	Language string
}

type Contact struct {
	Phone        string `json:"phone"`
	Availability string `json:"availability"`
	Website      string `json:"website"`
	Email        string `json:"email"`
}

type Resource struct {
	Type     string  `json:"type"`
	Name     string  `json:"name"`
	Contacts Contact `json:"contact"`
}

type Plans struct {
	Step        int    `json:"step"`
	Instruction string `json:"instruction"`
}

type Crisis struct {
	Region      string     `json:"region"`
	Resources   []Resource `json:"resources"`
	SafteyPlans []Plans    `json:"safety_plan"`
}

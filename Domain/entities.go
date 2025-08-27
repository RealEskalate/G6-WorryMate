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
	Language  string 
}

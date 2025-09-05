package domain

type User struct {
	Password string
	Role     string
	Username string
	Email    string
}

type Chat struct {
	Message        string
	// SenderIsAI     bool
	// TimeOfCreation time.Time
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
	Phone        string
	Availability string
	Website      string
	Email        string
}

type Resource struct {
	Type     string
	Name     string
	Contacts Contact
}

type Plans struct {
	Step        int
	Instruction string
}

type Crisis struct {
	Region      string
	Resources   []Resource
	SafteyPlans []Plans
}

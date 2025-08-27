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

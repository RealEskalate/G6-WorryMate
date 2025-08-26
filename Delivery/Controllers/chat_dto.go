package controllers

import "time"

type ChatDTO struct {
	Message        string 	 `json:"message"`
	SenderIsAI     bool		 `json:"senderisai"`
	TimeOfCreation time.Time `json:"timeofcreation"`
}
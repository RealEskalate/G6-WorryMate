package controllers

import domain "sema/Domain"

type ChatController struct {
	ChatUc domain.ChatUsecaseI
}

func NewChatController(uc domain.ChatUsecaseI) (*ChatController) {
	return &ChatController{
		ChatUc: uc,
	}
}

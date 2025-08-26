package controllers

import (
	domain "sema/Domain"

	"github.com/gofiber/fiber/v2"
)

type ChatController struct {
	ChatUc domain.ChatUsecaseI
}

func NewChatController(uc domain.ChatUsecaseI) (*ChatController) {
	return &ChatController{
		ChatUc: uc,
	}
}

func (cc *ChatController) ComposeCardController(c *fiber.Ctx) error {
	cc.ChatUc.ComposeCardUsecase();
	return nil
}
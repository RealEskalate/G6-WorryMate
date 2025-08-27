package controllers

import (
	domain "sema/Domain"

	"github.com/gofiber/fiber/v2"
)

type ChatController struct {
	ChatUc domain.ChatUsecaseI
}

func NewChatController(uc domain.ChatUsecaseI) *ChatController {
	return &ChatController{
		ChatUc: uc,
	}
}

func (cc *ChatController) ComposeCardController(c *fiber.Ctx) error {
	cc.ChatUc.ComposeCardUsecase()
	return nil
}

func (cc *ChatController) RiskCheckController(c *fiber.Ctx) error {
	var req struct {
		Content string `json:"content"`
	}
	if err := c.BodyParser(&req); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "invalid request"})
	}

	risk, tags, err := cc.ChatUc.RiskCheckUsecase(req.Content)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "internal server error"})
	}
	return c.JSON(fiber.Map{"risk": risk, "tags": tags})
}

func (cc *ChatController) IntentMappingController(c *fiber.Ctx) error {
	var req struct {
		Content string `json:"content"`
	}
	if err := c.BodyParser(&req); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "invalid request"})
	}
	key , err := cc.ChatUc.IntentMappingUsecase(req.Content)
	if err != nil{
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "internal server error"})
	}
	return c.JSON(fiber.Map{"key":key})

}

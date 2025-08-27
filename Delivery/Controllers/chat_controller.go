package controllers

import (
	"net/http"
	domain "sema/Domain"

	"github.com/gin-gonic/gin"
)

type ChatController struct {
	ChatUc domain.ChatUsecaseI
}

func NewChatController(uc domain.ChatUsecaseI) (*ChatController) {
	return &ChatController{
		ChatUc: uc,
	}
}

func (cc *ChatController) ComposeCardController(c *gin.Context) {
	var actBlk ActionBlockDTO 
	err := c.ShouldBindJSON(&actBlk)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error" : "invalid JSON format. unable to bind!"})
		return 
	}


	result, err := cc.ChatUc.ComposeCardUsecase(ChangeToDomain(actBlk));
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error" : err.Error()})
		return 
	}

	c.JSON(http.StatusOK, gin.H{"message" : "action card generated successfully", "card" : result})
}
package controllers

import (
	"net/http"
	domain "sema/Domain"

	"github.com/gin-gonic/gin"
)

type ChatController struct {
	ChatUc domain.ChatUsecaseI
}

func NewChatController(uc domain.ChatUsecaseI) *ChatController {
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

func (cc *ChatController) RiskCheckController(c *gin.Context) {
	var req struct {
		Content string `json:"content"`
	}
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "invalid request"})
		return
	}

	risk, tags, err := cc.ChatUc.RiskCheckUsecase(req.Content)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error" : err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message" : "Risk Calculated successfully!", "risk" : risk, "tags" : tags})
}

func (cc *ChatController) IntentMappingController(c *gin.Context) {
	var req struct {
		Content string `json:"content"`
	}
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "invalid request"})
		return 
	}
	key , err := cc.ChatUc.IntentMappingUsecase(req.Content)
	if err != nil{
		c.JSON(http.StatusInternalServerError, gin.H{"error" : err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"topic_key" : key})
}

package controllers

import (
	"encoding/json"
	"net/http"
	"os"
	"path/filepath"
	domain "sema/Domain"
	"strings"

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
		c.JSON(http.StatusBadRequest, gin.H{"error": "invalid JSON format. unable to bind!"})
		return
	}

	result, err := cc.ChatUc.ComposeCardUsecase(ChangeToDomain(actBlk))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "action card generated successfully", "card": result})
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
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Risk Calculated successfully!", "risk": risk, "tags": tags})
}

func (cc *ChatController) IntentMappingController(c *gin.Context) {
	var req struct {
		Content string `json:"content"`
	}
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "invalid request"})
		return
	}
	key, err := cc.ChatUc.IntentMappingUsecase(req.Content)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"topic_key": key})
}

func (cc *ChatController) ResourceController(c *gin.Context) {
	region := c.Query("region")
	if region == "" {
		region = "ET"
	}

	region = strings.ToUpper(region)
	path := filepath.Join("assets", "resources/region", region+".json")
	data, err := os.ReadFile(path)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error: ": "resources for region " + region + " not found"})
		return
	}

	var jsonData interface{}
	if err := json.Unmarshal(data, &jsonData); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error: ": "Invalid JSON format"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"resources: ": jsonData})
}

func (cc *ChatController) ActionBlockController(c *gin.Context) {
	topic_key := c.Param("topic_key")
	lang := c.Param("lang")
	actBlk, err := cc.ChatUc.GetActionBlockUsecase(topic_key, lang)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error" : err.Error()})
		return 
	}
	c.JSON(http.StatusOK, gin.H{"action_block" : actBlk})
}

func (cc *ChatController) OfflinePackController(c *gin.Context) {
	path := filepath.Join("assets", "offline-pack", "offline_pack.json")
	data, err := os.ReadFile(path)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error: ": "can not find offline pack in assets."})
		return
	}

	var jsonData interface{}
	if err := json.Unmarshal(data, &jsonData); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error: ": "Invalid JSON format"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"action-block: ": jsonData})
}

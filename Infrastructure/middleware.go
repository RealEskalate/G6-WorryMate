package infrastructure

import (
	"encoding/json"
	"net/http"
	"os"
	"path/filepath"
	"strings"

	"github.com/gin-gonic/gin"
)

func OfflinePackMiddleware(basepath string) gin.HandlerFunc {
	return func(c *gin.Context) {
		lang := c.Query("lang")
		if lang == "" {
			lang = "en"
		}
		path := filepath.Join(basepath, "offline-pack", "offline-pack."+lang+".json")
		data, err := os.ReadFile(path)
		if err != nil {
			c.JSON(http.StatusNotFound, gin.H{"error: ": "offline-pack not found for language " + lang}) 
			c.Abort()
			return  
		}

		var jsonData interface{}
		if err := json.Unmarshal(data, &jsonData); err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error: ": "Invalid JSON format"})
			c.Abort()
			return 
		}
		// c.JSON(http.StatusOK, gin.H{"data" : jsonData})
		c.Set("data", jsonData)
		c.Next()
	}
}

func ResourcesMiddleware(basepath string) gin.HandlerFunc {
	return func(c *gin.Context) {
		region := c.Query("region")
		if region == "" {
			region = "ET"
		}

		region = strings.ToUpper(region)
		path := filepath.Join(basepath, "resources/region", region+".json")
		data, err := os.ReadFile(path)
		if err != nil {
			c.JSON(http.StatusNotFound, gin.H{"error: ": "resources for region " + region + " not found"})
			c.Abort()
			return 
		}

		var jsonData interface{}
		if err := json.Unmarshal(data, &jsonData); err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error: ": "Invalid JSON format"})
			c.Abort()
			return 
		}
		// c.JSON(http.StatusOK, gin.H{"data" : jsonData})
		c.Set("data", jsonData)
		c.Next()
	}
}

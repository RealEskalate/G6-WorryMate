package routers

import (
	controllers "sema/Delivery/Controllers"
	infrastructure "sema/Infrastructure"

	"github.com/gin-gonic/gin"
)

func SetupRouter(ChtCtrl *controllers.ChatController) {
	router := gin.Default()

	// Chat routes 
	chatRoutes := router.Group("/chat")
	chatRoutes.Use(infrastructure.OfflinePackMiddleware("assets"), infrastructure.ResourcesMiddleware("assets")) 
	{	
		chatRoutes.POST("/compose")
    chatRoutes.POST("/risk_check")
    chatRoutes.POST("/intent_mapping")
	}

	// Run the app
	router.Run();
}

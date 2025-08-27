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
		chatRoutes.POST("/compose", ChtCtrl.ComposeCardController)
		chatRoutes.POST("/risk_check", ChtCtrl.RiskCheckController)
		chatRoutes.POST("/intent_mapping", ChtCtrl.IntentMappingController)
	}

	// Run the app
	router.Run();
}

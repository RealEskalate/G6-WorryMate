package routers

import (
	controllers "sema/Delivery/Controllers"

	"github.com/gin-gonic/gin"
)

func SetupRouter(ChtCtrl *controllers.ChatController) {
	router := gin.Default()

	// Chat routes
	chatRoutes := router.Group("/chat")
	{
		chatRoutes.POST("/compose", ChtCtrl.ComposeCardController)
		chatRoutes.POST("/risk_check", ChtCtrl.RiskCheckController)
		chatRoutes.POST("/intent_mapping", ChtCtrl.IntentMappingController)
		chatRoutes.GET("/resources", ChtCtrl.ResourceController)
		chatRoutes.GET("/offline-pack", ChtCtrl.OfflinePackController)
	}

	// Run the app
	router.Run()
}

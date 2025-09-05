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
		chatRoutes.POST("/normal", ChtCtrl.NormalChatController)
		chatRoutes.POST("/compose", ChtCtrl.ComposeCardController)
		chatRoutes.POST("/risk_check", ChtCtrl.RiskCheckController)
		chatRoutes.POST("/intent_mapping", ChtCtrl.IntentMappingController)
		chatRoutes.GET("/resources", ChtCtrl.ResourceController)
		chatRoutes.GET("/offline_pack", ChtCtrl.OfflinePackController)
		chatRoutes.GET("/action_block/:topic_key/:lang", ChtCtrl.ActionBlockController)
		chatRoutes.POST("/crisis_card", ChtCtrl.CrisisCardController)
	}

	// Run the app
	router.Run()
}

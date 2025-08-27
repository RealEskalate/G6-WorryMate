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
		chatRoutes.POST("/compose")
	}
	
	// Run the app
	router.Run();
}
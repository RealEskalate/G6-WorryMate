package routers

import (
	controllers "sema/Delivery/Controllers"

	"github.com/gofiber/fiber/v2"
)

func SetupRouter(UserCtrl *controllers.UserController, ChtCtrl *controllers.ChatController) {
	app := fiber.New()

	// Chat routes 
	chatRoutes := app.Group("/chat") 
	{
		
	}
	
	// Run the app
	app.Listen(":8080");
}
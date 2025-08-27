package routers

import (
	controllers "sema/Delivery/Controllers"
	infrastructure "sema/Infrastructure"

	"github.com/gofiber/fiber/v2"
)

func SetupRouter(ChtCtrl *controllers.ChatController) {
	app := fiber.New()

	// Chat routes
	chatRoutes := app.Group("/chat", infrastructure.OfflinePackMiddleware("assets"), infrastructure.ResourcesMiddleware("assets"))
	{
		chatRoutes.Get("/compose", func(c *fiber.Ctx) error {
			return ChtCtrl.ComposeCardController(c)
		})

		chatRoutes.Post("/risk_check", func(c *fiber.Ctx) error {
			return ChtCtrl.RiskCheckController(c)
		})

		chatRoutes.Post("/intent_mapping", func(c *fiber.Ctx) error {
			return ChtCtrl.IntentMappingController(c)
		})
	}

	// Run the app
	app.Listen(":8080")
}

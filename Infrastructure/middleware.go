package infrastructure

import (
	"encoding/json"
	"os"
	"path/filepath"
	"strings"

	"github.com/gofiber/fiber/v2"
)

func OfflinePackMiddleware(basepath string) fiber.Handler {
	return func(c *fiber.Ctx) error {
		lang := c.Query("lang", "en")
		path := filepath.Join(basepath, "offline-pack", "offline-pack."+lang+".json")
		data, err := os.ReadFile(path)
		if err != nil {
			return c.Status(fiber.StatusNotFound).JSON(fiber.Map{"error: ": "offline-pack not found for language " + lang})
		}

		var jsonData interface{}
		if err := json.Unmarshal(data, &jsonData); err != nil {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error: ": "Invalid JSON format"})
		}
		c.JSON(jsonData)
		return c.Next()
	}
}

func ResourcesMiddleware(basepath string) fiber.Handler {
	return func(c *fiber.Ctx) error {
		region := c.Query("region", "ET")
		region = strings.ToUpper(region)
		path := filepath.Join(basepath, "resources/region", region+".json")
		data, err := os.ReadFile(path)
		if err != nil {
			return c.Status(fiber.StatusNotFound).JSON(fiber.Map{"error: ": "resources for region " + region + " not found"})
		}

		var jsonData interface{}
		if err := json.Unmarshal(data, &jsonData); err != nil {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error: ": "Invalid JSON format"})
		}
		return c.JSON(jsonData)
		// return c.Next()
	}
}

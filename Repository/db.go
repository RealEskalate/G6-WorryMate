package repository

import (
	"context"
	"fmt"
	"log"
	"os"

	"github.com/joho/godotenv"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
)

// func InitializeDB() (*mongo.Database) {
// 	err := godotenv.Load(".env")
// 	if err != nil {
// 		log.Fatal("error while loading environment variables for database")
// 	}

// 	// Initialize options
// 	DB_URL := os.Getenv("MONGO_URL")

// 	clientOptions := options.Client().ApplyURI(DB_URL)
// 	client, err := mongo.Connect(context.TODO(), clientOptions)

// 	if err != nil {
// 		log.Fatal("Unable to connect to mongo database.")
// 	}

// 	return client.Database("Sema_db");
// }



func InitializeDB() *mongo.Database {
    // Only load .env locally
    _ = godotenv.Load(".env")

    DB_URL := os.Getenv("MONGO_URL")
    wd, _:= os.Getwd()
    fmt.Println("Current working directory: ", wd)
    if DB_URL == "" {
        log.Fatal("MONGO_URL not set")
    }

    clientOptions := options.Client().ApplyURI(DB_URL)
    client, err := mongo.Connect(context.TODO(), clientOptions)
    if err != nil {
        log.Fatal("Unable to connect to mongo database:", err)
    }

    return client.Database("Sema_db")
}
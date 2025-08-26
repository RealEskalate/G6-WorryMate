package repository

import "go.mongodb.org/mongo-driver/mongo"

type ChatRepository struct {
	ChatsCollection *mongo.Collection
}

func NewChatRepo(db *mongo.Database) (*ChatRepository) {
	return &ChatRepository{
		ChatsCollection: db.Collection("chats"),
	}
}


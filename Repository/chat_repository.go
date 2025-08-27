package repository

import (
	"encoding/json"
	"log"
	"os"
	domain "sema/Domain"

	"go.mongodb.org/mongo-driver/mongo"
)

type ChatRepository struct {
	ChatsCollection *mongo.Collection
	ActionBlocks []ActionBlockDTO
}

func NewChatRepo(db *mongo.Database) (*ChatRepository) {
	data, err := os.ReadFile("assets/offline-pack/offline_pack.json")
	if err != nil {
		log.Fatal("error loading offline pack file")
	}
	var actBlks []ActionBlockDTO
	err = json.Unmarshal(data, &actBlks)
	if err != nil {
		log.Fatal("error while reading from offline pack data.")
	}
	return &ChatRepository{
		ChatsCollection: db.Collection("chats"),
		ActionBlocks: actBlks,
	}
}

func (repo *ChatRepository) GetActionBlock(topic_key, lang string) (*domain.ActionBlock, bool) {
	for _, content := range(repo.ActionBlocks) {
		if content.Language == lang && content.TopicKey == topic_key {
			return  ChangeToDomain(content), true 
		}
	}
	return &domain.ActionBlock{}, false
}
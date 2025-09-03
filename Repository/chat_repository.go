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
	ActionBlocks    []ActionBlockDTO
	Resources       []CrisisDto
}

func NewChatRepo(db *mongo.Database) *ChatRepository {
	data, err := os.ReadFile("assets/offline-pack/offline_pack.json")
	if err != nil {
		log.Fatal("error loading offline pack file")
	}
	var actBlks []ActionBlockDTO
	err = json.Unmarshal(data, &actBlks)
	if err != nil {
		log.Fatal("error while reading from offline pack data.")
	}

	data, err = os.ReadFile("assets/resources/region.json")
	if err != nil {
		log.Fatal("error while reading resources file")
	}
	var crisis []CrisisDto
	err = json.Unmarshal(data, &crisis)
	if err != nil {
		log.Fatal("error while unmarshaling resource data.")
	}
	return &ChatRepository{
		ChatsCollection: db.Collection("chats"),
		ActionBlocks:    actBlks,
		Resources:       crisis,
	}
}

func (repo *ChatRepository) GetActionBlock(topic_key, lang string) (*domain.ActionBlock, bool) {
	for _, content := range repo.ActionBlocks {
		if content.Language == lang && content.TopicKey == topic_key {
			return ChangeToDomain(content), true
		}
	}
	return &domain.ActionBlock{}, false
}

func (repo *ChatRepository) GetoffPack(lang string) ([]*domain.ActionBlock, bool) {
	var responses []*domain.ActionBlock
	for _, content := range repo.ActionBlocks {
		if content.Language == lang {
			responses = append(responses, ChangeToDomain(content))
		}
	}
	if len(responses) == 0 {
		return nil, false
	}
	return responses, true
}

func (repo *ChatRepository) GetResource(region string) ([]*domain.Crisis, bool) {
	var responses []*domain.Crisis
	for _, content := range repo.Resources {
		if content.Region == region {
			responses = append(responses, ChangeToDomainCrisis(content))
		}
	}
	if len(responses) == 0 {
		return nil, false
	}
	return responses, true

}

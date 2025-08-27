package usecase

import (
	"encoding/json"
	"errors"
	"os"
	domain "sema/Domain"
)

type ChatUsecase struct {
	ChatRepo domain.ChatRepositoryI
	aiServ   domain.AIService
}

func NewChatUsecase(chtrp domain.ChatRepositoryI, ai domain.AIService) *ChatUsecase {
	return &ChatUsecase{
		ChatRepo: chtrp,
		aiServ:   ai,
	}
}

func (cu *ChatUsecase) ComposeCardUsecase(actBlk *domain.ActionBlock) (*string, error) {
	return cu.aiServ.GenerateActionCard(actBlk)
}

func (cu *ChatUsecase) RiskCheckUsecase(content string) (int, []string, error) {
	return cu.aiServ.GenerateRiskCheck(content)
}

func (cu *ChatUsecase) IntentMappingUsecase(content string) (string, error) {
	return cu.aiServ.GenerateTopicKey(content)
}

func (cu *ChatUsecase) ReadResourcesUseCase(respath, region string) ([]domain.Crisis, error) {
	var response []domain.Crisis
	data, err := os.ReadFile(respath)
	if err != nil {
		return response, errors.New("resource not found")
	}
	var temp []domain.Crisis
	if err := json.Unmarshal(data, &temp); err != nil {
		return response, errors.New("invalid json format")
	}

	var responses []domain.Crisis
	for _, r := range temp {
		if r.Region == region {
			responses = append(responses, r)
		}
	}
	return responses, nil
}

func (cu *ChatUsecase) CrisisCardUseCase(topic string)

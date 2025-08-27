package usecase

import (
	domain "sema/Domain"
)

type ChatUsecase struct {
	ChatRepo domain.ChatRepositoryI
	aiServ domain.AIService
}

func NewChatUsecase(chtrp domain.ChatRepositoryI, ai domain.AIService) (*ChatUsecase) {
	return &ChatUsecase{
		ChatRepo: chtrp,
		aiServ: ai,
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
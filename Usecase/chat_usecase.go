package usecase

import (
	domain "sema/Domain"
	infrastructure "sema/Infrastructure"
)

type ChatUsecase struct {
	ChatRepo domain.ChatRepositoryI
	gemini   *infrastructure.AI
}

func NewChatUsecase(chtrp domain.ChatRepositoryI) (*ChatUsecase) {
	return &ChatUsecase{
		ChatRepo: chtrp,
		gemini:   infrastructure.InitAIClient(),
	}
	}


func (cu *ChatUsecase) ComposeCardUsecase() {
	
}

func (cu *ChatUsecase) RiskCheckUsecase(content string) (int, []string, error) {
	return cu.gemini.GenerateRiskCheck(content)
}

func (cu *ChatUsecase) IntentMappingUsecase(content string) (string, error) {
	return cu.gemini.GenerateTopicKey(content)
}
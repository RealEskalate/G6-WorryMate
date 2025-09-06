package usecase

import (
	"errors"
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

func (cu *ChatUsecase) NormalChatUsecase(message, context string) (string, error) {
	return cu.aiServ.GenerateNormalChatMsg(message, context)
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

func (cu *ChatUsecase) GetActionBlockUsecase(topic_key, lang string) (*domain.ActionBlock, error) {
	res, ok := cu.ChatRepo.GetActionBlock(topic_key, lang)
	if !ok {
		return &domain.ActionBlock{}, errors.New("can not find action block with this topic item")
	}
	return res, nil
}

func (cu *ChatUsecase) GetResourcesUseCase(region string) ([]*domain.Crisis, error) {
	res, ok := cu.ChatRepo.GetResource(region)
	if !ok {
		return nil, errors.New("can not find resources for region: " + region)
	}
	return res, nil
} 

func (cu *ChatUsecase) GetOffLinePackUseCase(lang string) ([]*domain.ActionBlock, error) {
	res, ok := cu.ChatRepo.GetoffPack(lang)
	if !ok {
		return nil, errors.New("can not find action blocks with language " + lang)
	}
	return res, nil
}

func (cu *ChatUsecase) GenerateCrisisCard(lang, region string, tags []string) (*string, error) {
	return cu.aiServ.GenerateCrisisCard(lang, region, tags)
}

func (cu *ChatUsecase) SummarizeUsecase(content string) (string, error) {
	return cu.aiServ.GenerateSummary(content)
}

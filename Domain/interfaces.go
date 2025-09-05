package domain

type UserUsecaseI interface{}
type UserRepositoryI interface{}
type ChatUsecaseI interface {
	ComposeCardUsecase(*ActionBlock) (*string, error)
	RiskCheckUsecase(message string) (int, []string, error)
	IntentMappingUsecase(message string) (string, error)
	GetResourcesUseCase(region string) ([]*Crisis, error)
	GetActionBlockUsecase(topic_key, lang string) (*ActionBlock, error)
	GetOffLinePackUseCase(lang string) ([]*ActionBlock, error)
	GenerateCrisisCard(lang, region string, tags []string) (*string, error)
	NormalChatUsecase(message string) (string, error)
}
type ChatRepositoryI interface {
	GetActionBlock(topic_key, lang string) (*ActionBlock, bool)
	GetoffPack(lang string) ([]*ActionBlock, bool)
	GetResource(region string) ([]*Crisis, bool)
}
type AIService interface {
	GenerateActionCard(actionBlock *ActionBlock) (*string, error)
	GenerateTopicKey(content string) (string, error)
	GenerateRiskCheck(content string) (int, []string, error)
	GenerateCrisisCard(lang, region string, tags []string) (*string, error)
	GenerateNormalChatMsg(msg string) (string, error)
}

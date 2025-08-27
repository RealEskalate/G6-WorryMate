package domain

type UserUsecaseI interface{}
type UserRepositoryI interface{}
type ChatUsecaseI interface {
	ComposeCardUsecase(*ActionBlock) (*string, error)
	RiskCheckUsecase(message string) (int, []string, error)
	IntentMappingUsecase(message string) (string, error)
	GetActionBlockUsecase(topic_key, lang string) (*ActionBlock, error)
}
type ChatRepositoryI interface {
	GetActionBlock(topic_key, lang string) (*ActionBlock, bool)
}
type AIService interface {
	GenerateActionCard(actionBlock *ActionBlock) (*string, error)
	GenerateTopicKey(content string) (string, error)
	GenerateRiskCheck(content string) (int, []string, error)
}
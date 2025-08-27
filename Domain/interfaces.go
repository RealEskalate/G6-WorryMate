package domain

type UserUsecaseI interface{}
type UserRepositoryI interface{}
type ChatUsecaseI interface {
	ComposeCardUsecase(*ActionBlock) (*string, error)
	RiskCheckUsecase(message string) (int, []string, error)
	IntentMappingUsecase(message string) (string, error)
	ReadResourcesUseCase(path, region string) ([]Crisis, error)
}
type ChatRepositoryI interface{}
type AIService interface {
	GenerateActionCard(actionBlock *ActionBlock) (*string, error)
	GenerateTopicKey(content string) (string, error)
	GenerateRiskCheck(content string) (int, []string, error)
	GenerateCrisisCard(content *Crisis, lang string, tags []string) (*string, error)
}

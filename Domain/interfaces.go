package domain

type UserUsecaseI interface{}
type UserRepositoryI interface{}
type ChatUsecaseI interface{
	ComposeCardUsecase(*ActionBlock) (*string, error)
	RiskCheckUsecase(message string) (int, []string, error)
	IntentMappingUsecase(message string)(string, error)
}
type ChatRepositoryI interface{}
type AIService interface {
	GenerateActionCard(actionBlock *ActionBlock) (*string, error)
}
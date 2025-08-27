package domain

type UserUsecaseI interface{}
type UserRepositoryI interface{}
type ChatUsecaseI interface {
	ComposeCardUsecase(*ActionBlock) (*string, error)
}
type ChatRepositoryI interface{}
type AIService interface {
	GenerateActionCard(actionBlock *ActionBlock) (*string, error)
}
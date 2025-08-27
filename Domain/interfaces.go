package domain

type UserUsecaseI interface{}
type UserRepositoryI interface{}
type ChatUsecaseI interface{
	ComposeCardUsecase()
	RiskCheckUsecase(message string) (int, []string, error)
	IntentMappingUsecase(message string)(string, error)
}
type ChatRepositoryI interface{}
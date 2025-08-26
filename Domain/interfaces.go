package domain

type UserUsecaseI interface{}
type UserRepositoryI interface{}
type ChatUsecaseI interface{
	ComposeCardUsecase()
}
type ChatRepositoryI interface{}
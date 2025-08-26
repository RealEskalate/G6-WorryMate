package usecase

import domain "sema/Domain"

type UserUsecase struct {
	UserRepo domain.UserRepositoryI
}

func NewUserUsecase(usrp domain.UserRepositoryI) (*UserUsecase) {
	return &UserUsecase{
		UserRepo: usrp,
	}
}

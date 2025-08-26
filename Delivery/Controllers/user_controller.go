package controllers

import domain "sema/Domain"

type UserController struct {
	UserUc domain.UserUsecaseI
}

func NewUserController(uc domain.UserUsecaseI) (*UserController) {
	return &UserController{
		UserUc: uc,
	}
}

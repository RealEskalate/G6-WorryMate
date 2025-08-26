package usecase

import domain "sema/Domain"

type ChatUsecase struct {
	ChatRepo domain.ChatRepositoryI
}

func NewChatUsecase(chtrp domain.ChatRepositoryI) (*ChatUsecase) {
	return &ChatUsecase{
		ChatRepo: chtrp,
	}
}

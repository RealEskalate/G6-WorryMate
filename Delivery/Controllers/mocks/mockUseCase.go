package mocks

import "github.com/stretchr/testify/mock"

type MockUseCase struct {
	mock.Mock
}

func (m *MockUseCase) ComposeCardController(){
	
}
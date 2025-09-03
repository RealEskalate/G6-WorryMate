package usecase

import (
	"errors"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/mock"
	"github.com/stretchr/testify/suite"

	domain "sema/Domain"
	"sema/Controllers/mocks"
	"sema/Controllers/mocks"
)

// ChatUsecaseSuite is the test suite for the ChatUsecase.
type ChatUsecaseSuite struct {
	suite.Suite
	chatUsecase   *ChatUsecase
	mockChatRepo  *mock_repo.ChatRepo
	mockAIService *mock_service.AIService
}

// SetupTest initializes the mock dependencies and the use case before each test.
func (suite *ChatUsecaseSuite) SetupTest() {
	suite.mockChatRepo = new(mock_repo.ChatRepo)
	suite.mockAIService = new(mock_service.AIService)
	suite.chatUsecase = NewChatUsecase(suite.mockChatRepo, suite.mockAIService)
}

// TearDownTest asserts that all mock expectations were met after each test.
func (suite *ChatUsecaseSuite) TearDownTest() {
	suite.mockChatRepo.AssertExpectations(suite.T())
	suite.mockAIService.AssertExpectations(suite.T())
}

// TestComposeCardUsecase_Positive tests the successful generation of a composed card.
func (suite *ChatUsecaseSuite) TestComposeCardUsecase_Positive() {
	// Arrange: Set up the mock expectations and test data.
	actionBlock := &domain.ActionBlock{
		Topic: "motivation",
		Text:  "Hello there",
	}
	expectedResult := "This is composed card result"

	// Mockery automatically handles the mock methods. We only need to set the
	// expected behavior with On().
	// We assume a call to GetActionBlock, followed by GenerateActionCard.
	suite.mockChatRepo.On("GetActionBlock", "motivation", "en").Return(actionBlock, true)
	suite.mockAIService.On("GenerateActionCard", actionBlock).Return(&expectedResult, nil)

	// Act: Call the method you want to test on the use case.
	// You need to replace this with your actual use case method call.
	result, err := suite.chatUsecase.ComposeCardUsecase("motivation", "en")

	// Assert: Check the results and that no error was returned.
	suite.Require().NoError(err, "ComposeCardUsecase should not return an error")
	suite.Require().Equal(&expectedResult, result, "The returned result should match the expected result")
}

// TestChatUsecaseSuite runs the test suite.
func TestChatUsecaseSuite(t *testing.T) {
	suite.Run(t, new(ChatUsecaseSuite))
}
package usecase

import (
	"sema/Delivery/mocks"
	domain "sema/Domain"
	"testing"

	"github.com/stretchr/testify/suite"
)

type ChatUsecaseTestSuite struct {
	suite.Suite
	ChtUsecase *ChatUsecase
	repo *mocks.ChatRepositoryI
	ai_serv *mocks.AIService
}

func (suite *ChatUsecaseTestSuite) SetupSuite() {
	rp := new(mocks.ChatRepositoryI)
	ai := new(mocks.AIService)
	
	uc := NewChatUsecase(rp, ai)
	suite.ChtUsecase = uc 
	suite.repo = rp
	suite.ai_serv = ai
}

var testMsg = "Hi"
var testTopicKy = "study_stress"
var testLang = "en"

func (suite *ChatUsecaseTestSuite) TestNormalChat_Positive() {
	// Setup expected response on ai_service
	suite.ai_serv.On("GenerateNormalChatMsg", testMsg).Return("hello", nil)
	// call and assert
	ans, err := suite.ChtUsecase.NormalChatUsecase(testMsg)
	suite.Assert().NoError(err, "no error expected when sending valid message to ai")
	suite.Assert().Equal(ans, "hello", "same response as from ai is expected")
	suite.ai_serv.AssertExpectations(suite.T())
}

func (suite *ChatUsecaseTestSuite) TestGetActionBlock_Positive() {
	// Setup expected response on repo
	suite.repo.On("GetActionBlock", testTopicKy, testLang).Return(&domain.ActionBlock{}, true)

	// call and assert 
	_, err := suite.ChtUsecase.GetActionBlockUsecase(testTopicKy, testLang)
	suite.Assert().NoError(err, "no error expected when getting valid action block")
	suite.repo.AssertExpectations(suite.T())
}

// Searching for a non existent action block case
func (suite *ChatUsecaseTestSuite) TestGetActionBlock_Negative() {
	// Setup expected response on repo
	suite.repo.On("GetActionBlock", testTopicKy, "").Return(&domain.ActionBlock{}, false)

	// call and assert
	_, err := suite.ChtUsecase.GetActionBlockUsecase(testTopicKy, "")
	suite.Assert().Error(err, "error expected when searching for an invalid action block")
	suite.repo.AssertExpectations(suite.T())
}

func (suite *ChatUsecaseTestSuite) TestGetResources_Positive() {
	// Setup expected response on repo
	suite.repo.On("GetResource", "ET").Return([]*domain.Crisis{}, true)

	// call and assert
	_, err := suite.ChtUsecase.GetResourcesUseCase("ET")
	suite.Assert().NoError(err, "no error expected when getting resources for a valid region")
	suite.repo.AssertExpectations(suite.T())
}

// Non existing region case check
func (suite *ChatUsecaseTestSuite) TestGetResources_Negative() {
	// Setup expected response on repo 
	suite.repo.On("GetResource", "AM").Return([]*domain.Crisis{}, false)

	// call and assert
	_, err := suite.ChtUsecase.GetResourcesUseCase("AM")
	suite.Assert().Error(err, "error expected when trying to get invalid region resources")
	suite.repo.AssertExpectations(suite.T())
}

func (suite *ChatUsecaseTestSuite) TestGetOfflinePack_Positive() {
	// Setup expected response on repo
	suite.repo.On("GetoffPack", "en").Return([]*domain.ActionBlock{}, true)

	// call and assert
	_, err := suite.ChtUsecase.GetOffLinePackUseCase("en")
	suite.Assert().NoError(err, "no error expected when searching for valid offline pack")
	suite.repo.AssertExpectations(suite.T())
}

// Non existing language for offline pack case check
func (suite *ChatUsecaseTestSuite) TestGetofflinePack_Negative() {
	// Setup expected response on repo
	suite.repo.On("GetoffPack", "ch").Return([]*domain.ActionBlock{}, false)

	// call and assert
	_, err := suite.ChtUsecase.GetOffLinePackUseCase("ch")
	suite.Assert().Error(err, "error expected when searching for invalid offline pack")
}

func TestChatUsecaseSuite(t *testing.T) {
	// Run the suite
	suite.Run(t, new(ChatUsecaseTestSuite))
}
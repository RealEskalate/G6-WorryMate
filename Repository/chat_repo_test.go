package repository

import (
	"testing"

	"github.com/stretchr/testify/suite"
)

type ChatReposiotorySuite struct {
	suite.Suite
	chtRepo ChatRepository 
}

func (suite *ChatReposiotorySuite) SetupSuite() {
	db := InitializeDB()
	suite.chtRepo = *NewChatRepo(db)
}

func (suite *ChatReposiotorySuite) TestGetActionBlock_Positive() {
	// Call the function with valid inputs and assert true
	_, ok := suite.chtRepo.GetActionBlock("motivation", "en")
	suite.Assert().True(ok, "true result expected when looking for valid token key and language")
}

func (suite *ChatReposiotorySuite) TestGetActionBlock_Negative() {
	// Call function with non existent topic key and assert false
	_, ok := suite.chtRepo.GetActionBlock("unknown", "en")
	suite.Assert().False(ok, "false expected when looking for an invalid token key")
}

func (suite *ChatReposiotorySuite) TestGetActionBlock_Negative_InvalidLang() {
	// Call function with valid topic key but invalid language
	_, ok := suite.chtRepo.GetActionBlock("motivation", "un")
	suite.Assert().False(ok, "false expected when looking for an invalid language")
}

func TestChatRepositorySuite(t *testing.T) {
	// Run the suite
	suite.Run(t, new(ChatReposiotorySuite))
}
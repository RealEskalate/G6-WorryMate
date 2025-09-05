package repository

import (
	"encoding/json"
	"log"
	"os"
	"testing"

	"github.com/stretchr/testify/suite"
)

type ChatRepositorySuite struct {
	suite.Suite
	chtRepo ChatRepository 
}

func InitializeTestChatRepo() (ChatRepository){
	// Read from the offline pack and set  up testing environment
	data, err := os.ReadFile("../assets/offline-pack/offline_pack.json")
	if err != nil {
		log.Fatal("error loading offline pack file")
	}
	var actBlks []ActionBlockDTO
	err = json.Unmarshal(data, &actBlks)
	if err != nil {
		log.Fatal("error while reading from offline pack data.")
	}

	data, err = os.ReadFile("../assets/resources/region.json")
	if err != nil {
		log.Fatal("error while reading resources file")
	}
	var crisis []CrisisDto
	err = json.Unmarshal(data, &crisis)
	if err != nil {
		log.Fatal("error while unmarshaling resource data.")
	}
	return ChatRepository{
		Resources: crisis,
		ActionBlocks: actBlks,
	}
}

func (suite *ChatRepositorySuite) SetupSuite() {
	suite.chtRepo = InitializeTestChatRepo()
}

func (suite *ChatRepositorySuite) TestGetActionBlock_Positive() {
	// Call the function with valid inputs and assert true
	_, ok := suite.chtRepo.GetActionBlock("motivation", "en")
	suite.Assert().True(ok, "true result expected when looking for valid token key and language")
}

func (suite *ChatRepositorySuite) TestGetActionBlock_Negative() {
	// Call function with non existent topic key and assert false
	_, ok := suite.chtRepo.GetActionBlock("unknown", "en")
	suite.Assert().False(ok, "false expected when looking for an invalid token key")
}

func (suite *ChatRepositorySuite) TestGetActionBlock_Negative_InvalidLang() {
	// Call function with valid topic key but invalid language
	_, ok := suite.chtRepo.GetActionBlock("motivation", "un")
	suite.Assert().False(ok, "false expected when looking for an invalid language")
}

func (suite *ChatRepositorySuite) TestGetoffPack_Positive() {
	_, ok := suite.chtRepo.GetoffPack("en")
	suite.Assert().True(ok, "expected to find offline pack for a valid language.")
}

// Non existing langage check
func (suite *ChatRepositorySuite) TestGetoffPack_Negative() {	
	_, ok := suite.chtRepo.GetoffPack("ch")
	suite.Assert().False(ok, "expected not found when asking for non exsisting language pack.")
}

func (suite *ChatRepositorySuite) TestGetResource_Positive() {
	_, ok := suite.chtRepo.GetResource("ET")
	suite.Assert().True(ok, "expected true when looking for a valid region resource pack")
}

// Non existing region check
func (suite *ChatRepositorySuite) TestGetResource_Negative() {
	_, ok := suite.chtRepo.GetResource("AM")
	suite.Assert().False(ok, "expected false when looking for an invalid region resource pack")
}

func TestChatRepositorySuite(t *testing.T) {
	// Run the suite
	suite.Run(t, new(ChatRepositorySuite))
}
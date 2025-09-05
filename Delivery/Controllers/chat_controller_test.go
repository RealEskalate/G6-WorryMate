package controllers

import (
	"bytes"
	"encoding/json"
	"errors"
	"net/http"
	"net/http/httptest"
	"sema/Delivery/mocks"
	domain "sema/Domain"
	"testing"

	"github.com/gin-gonic/gin"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/mock"
)

func setupTestRouter(controller *ChatController) *gin.Engine {
	gin.SetMode(gin.TestMode)
	router := gin.Default()
	
	// Manually set up the same routes as in router.go
	chatRoutes := router.Group("/chat")
	{
		chatRoutes.POST("/compose", controller.ComposeCardController)
		chatRoutes.POST("/risk_check", controller.RiskCheckController)
		chatRoutes.POST("/intent_mapping", controller.IntentMappingController)
		chatRoutes.GET("/resources", controller.ResourceController)
		chatRoutes.GET("/offline_pack", controller.OfflinePackController)
		chatRoutes.GET("/action_block/:topic_key/:lang", controller.ActionBlockController)
		chatRoutes.POST("/crisis_card", controller.CrisisCardController)
	}
	
	return router
}

func createTestRequest(method, path string, body interface{}) (*http.Request, error) {
	var req *http.Request
	var err error
	
	if body != nil {
		var jsonBytes []byte
		switch v := body.(type) {
		case string:
			jsonBytes = []byte(v)
		default:
			jsonBytes, err = json.Marshal(body)
			if err != nil {
				return nil, err
			}
		}
		req, err = http.NewRequest(method, path, bytes.NewBuffer(jsonBytes))
		if err != nil {
			return nil, err
		}
		req.Header.Set("Content-Type", "application/json")
	} else {
		req, err = http.NewRequest(method, path, nil)
		if err != nil {
			return nil, err
		}
	}
	
	return req, nil
}

func TestComposeCardController(t *testing.T) {
	tests := []struct {
		name           string
		input          interface{}
		mockSetup      func(*mocks.ChatUsecaseI)
		expectedStatus int
		expectedError  string
		expectedCard   string
	}{
		{
			name: "success",
			input: ActionBlockDTO{
				TopicKey: "family_conflict",
				Language: "en",
				Block: BlockDTO{
					EmpathyOpeners: []string{"I understand this is difficult", "It's okay to feel this way"},
					MicroSteps:     []string{"Take a deep breath", "Drink some water"},
					Scripts:        []string{"You can say: 'I need support right now'"},
					ToolLinks: []ToolLinkDTO{
						{Title: "Crisis Hotline", URL: "https://crisis.org"},
						{Title: "Self-Help Guide", URL: "https://selfhelp.org"},
					},
					IfWorse:    []string{"If symptoms worsen, contact emergency services"},
					Disclaimer: "This is not professional medical advice",
				},
			},
			mockSetup: func(mockUseCase *mocks.ChatUsecaseI) {
				result := "card_content"
				mockUseCase.On("ComposeCardUsecase", mock.AnythingOfType("*domain.ActionBlock")).
					Return(&result, nil)
			},
			expectedStatus: 200,
			expectedError:  "",
			expectedCard:   "card_content",
		},
		{
			name:  "Invalid JSON",
			input: `{invalid json}`,
			mockSetup: func(mockUseCase *mocks.ChatUsecaseI) {
				// No mock setup needed since JSON binding should fail before usecase is called
			},
			expectedStatus: http.StatusBadRequest,
			expectedError:  "invalid JSON format. unable to bind!",
			expectedCard:   "",
		},
		{
			name: "Usecase Error",
			input: ActionBlockDTO{
				TopicKey: "error_topic",
				Language: "en",
				Block: BlockDTO{
					EmpathyOpeners: []string{"test"},
					MicroSteps:     []string{"test"},
					Scripts:        []string{"test"},
					ToolLinks:      []ToolLinkDTO{},
					IfWorse:        []string{"test"},
					Disclaimer:     "test",
				},
			},
			mockSetup: func(mockUseCase *mocks.ChatUsecaseI) {
				mockUseCase.On("ComposeCardUsecase", mock.AnythingOfType("*domain.ActionBlock")).
					Return((*string)(nil), errors.New("usecase error"))
			},
			expectedStatus: 500,
			expectedError:  "usecase error",
			expectedCard:   "",
		},
		{
			name: "Rate Limit Error",
			input: ActionBlockDTO{
				TopicKey: "rate_limit_topic",
				Language: "en",
				Block: BlockDTO{
					EmpathyOpeners: []string{"test"},
					MicroSteps:     []string{"test"},
					Scripts:        []string{"test"},
					ToolLinks:      []ToolLinkDTO{},
					IfWorse:        []string{"test"},
					Disclaimer:     "test",
				},
			},
			mockSetup: func(mockUseCase *mocks.ChatUsecaseI) {
				mockUseCase.On("ComposeCardUsecase", mock.AnythingOfType("*domain.ActionBlock")).
					Return((*string)(nil), errors.New("quota/rate limit exceeded, please retry later"))
			},
			expectedStatus: http.StatusTooManyRequests,
			expectedError:  "quota/rate limit exceeded, please retry later",
			expectedCard:   "",
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			mockUseCase := mocks.NewChatUsecaseI(t)
			controller := &ChatController{ChatUc: mockUseCase}
			router := setupTestRouter(controller)
			
			tt.mockSetup(mockUseCase)
			
			req, err := createTestRequest("POST", "/chat/compose", tt.input)
			if err != nil {
				t.Fatalf("Could not create request: %v", err)
			}
			
			w := httptest.NewRecorder()
			router.ServeHTTP(w, req)
			
			assert.Equal(t, tt.expectedStatus, w.Code)
			
			if tt.expectedStatus == http.StatusOK {
				var response map[string]interface{}
				err = json.Unmarshal(w.Body.Bytes(), &response)
				if err != nil {
					t.Fatalf("Could not parse response: %v", err)
				}
				assert.Equal(t, "action card generated successfully", response["message"])
				assert.Equal(t, tt.expectedCard, response["card"])
			} else if tt.expectedError != "" {
				var response map[string]interface{}
				err = json.Unmarshal(w.Body.Bytes(), &response)
				if err != nil {
					t.Fatalf("Could not parse response: %v", err)
				}
				assert.Contains(t, response["error"].(string), tt.expectedError)
			}
			
		})
	}
}

func TestRiskCheckController(t *testing.T) {
	mockUseCase := mocks.NewChatUsecaseI(t)
	controller := &ChatController{ChatUc: mockUseCase}
	router := setupTestRouter(controller)
	
	// Setup mock
	mockUseCase.On("RiskCheckUsecase", "test message").Return(5, []string{"tag1", "tag2"}, nil)
	
	// Create request
	reqBody := map[string]string{"content": "test message"}
	req, _ := createTestRequest("POST", "/chat/risk_check", reqBody)
	w := httptest.NewRecorder()
	
	// Serve request
	router.ServeHTTP(w, req)
	
	// Assertions
	assert.Equal(t, http.StatusOK, w.Code)
	
	var response map[string]interface{}
	json.Unmarshal(w.Body.Bytes(), &response)
	
	assert.Equal(t, "Risk Calculated successfully!", response["message"])
	assert.Equal(t, float64(5), response["risk"])
	assert.Equal(t, []interface{}{"tag1", "tag2"}, response["tags"])
	
}

func TestIntentMappingController(t *testing.T) {
	mockUseCase := mocks.NewChatUsecaseI(t)
	controller := &ChatController{ChatUc: mockUseCase}
	router := setupTestRouter(controller)
	
	// Setup mock
	mockUseCase.On("IntentMappingUsecase", "test content").Return("test_topic", nil)
	
	// Create request
	reqBody := map[string]string{"content": "test content"}
	req, _ := createTestRequest("POST", "/chat/intent_mapping", reqBody)
	w := httptest.NewRecorder()
	
	// Serve request
	router.ServeHTTP(w, req)
	
	// Assertions
	assert.Equal(t, http.StatusOK, w.Code)
	
	var response map[string]interface{}
	json.Unmarshal(w.Body.Bytes(), &response)
	
	assert.Equal(t, "test_topic", response["topic_key"])
	
}

func TestResourceController(t *testing.T) {
	mockUseCase := mocks.NewChatUsecaseI(t)
	controller := &ChatController{ChatUc: mockUseCase}
	router := setupTestRouter(controller)
	
	// Setup mock
	crises := []*domain.Crisis{
		{
			Region: "ET",
			Resources: []domain.Resource{
				{
					Type: "Hotline",
					Name: "Test Hotline",
					Contacts: domain.Contact{
						Phone: "123-456-7890",
					},
				},
			},
		},
	}
	mockUseCase.On("GetResourcesUseCase", "ET").Return(crises, nil)
	
	// Create request
	req, _ := createTestRequest("GET", "/chat/resources?region=ET", nil)
	w := httptest.NewRecorder()
	
	// Serve request
	router.ServeHTTP(w, req)
	
	// Assertions
	assert.Equal(t, http.StatusOK, w.Code)
	
	var response map[string]interface{}
	json.Unmarshal(w.Body.Bytes(), &response)
	
	// The response should have key "resources: " (with space)
	assert.NotNil(t, response["resources: "])
	
}

func TestActionBlockController(t *testing.T) {
	mockUseCase := mocks.NewChatUsecaseI(t)
	controller := &ChatController{ChatUc: mockUseCase}
	router := setupTestRouter(controller)
	
	// Setup mock
	expectedBlock := &domain.ActionBlock{
		TopicKey: "test_topic",
		Language: "en",
		Block: domain.Block{
			EmpathyOpeners: []string{"opener1"},
			MicroSteps:     []string{"step1"},
			Scripts:        []string{"script1"},
			ToolLinks: []domain.ToolLink{
				{Title: "Test Tool", URL: "https://test.com"},
			},
			IfWorse:    []string{"if worse"},
			Disclaimer: "test disclaimer",
		},
	}
	mockUseCase.On("GetActionBlockUsecase", "test_topic", "en").Return(expectedBlock, nil)
	
	// Create request
	req, _ := createTestRequest("GET", "/chat/action_block/test_topic/en", nil)
	w := httptest.NewRecorder()
	
	// Serve request
	router.ServeHTTP(w, req)
	
	// Assertions
	assert.Equal(t, http.StatusOK, w.Code)
	
	// Parse the response directly into ActionBlockDTO since that's what ChangeToChatDTO returns
	var response ActionBlockDTO
	err := json.Unmarshal(w.Body.Bytes(), &response)
	if err != nil {
		t.Fatalf("Could not parse response: %v", err)
	}
	
	// Check that the response contains the expected data
	assert.Equal(t, "test_topic", response.TopicKey)
	assert.Equal(t, "en", response.Language)
	assert.Equal(t, []string{"opener1"}, response.Block.EmpathyOpeners)
	assert.Equal(t, []string{"step1"}, response.Block.MicroSteps)
	assert.Equal(t, []string{"script1"}, response.Block.Scripts)
	assert.Equal(t, []string{"if worse"}, response.Block.IfWorse)
	assert.Equal(t, "test disclaimer", response.Block.Disclaimer)
	assert.Len(t, response.Block.ToolLinks, 1)
	assert.Equal(t, "Test Tool", response.Block.ToolLinks[0].Title)
	assert.Equal(t, "https://test.com", response.Block.ToolLinks[0].URL)
	
}

func TestOfflinePackController(t *testing.T) {
	mockUseCase := mocks.NewChatUsecaseI(t)
	controller := &ChatController{ChatUc: mockUseCase}
	router := setupTestRouter(controller)
	
	// Setup mock
	actionBlocks := []*domain.ActionBlock{
		{
			TopicKey: "test_topic",
			Language: "en",
			Block: domain.Block{
				EmpathyOpeners: []string{"test"},
			},
		},
	}
	mockUseCase.On("GetOffLinePackUseCase", "").Return(actionBlocks, nil)
	
	// Create request
	req, _ := createTestRequest("GET", "/chat/offline_pack", nil)
	w := httptest.NewRecorder()
	
	// Serve request
	router.ServeHTTP(w, req)
	
	// Assertions
	assert.Equal(t, http.StatusOK, w.Code)
	
	var response map[string]interface{}
	json.Unmarshal(w.Body.Bytes(), &response)
	
	// The response should have key "action-block: " (with space)
	assert.NotNil(t, response["action-block: "])
	
}

func TestCrisisCardController(t *testing.T) {
	mockUseCase := mocks.NewChatUsecaseI(t)
	controller := &ChatController{ChatUc: mockUseCase}
	router := setupTestRouter(controller)
	
	// Setup mock
	result := "crisis_card_content"
	mockUseCase.On("GenerateCrisisCard", "EN", "ET", []string{"emergency", "crisis"}).Return(&result, nil)
	
	// Create request
	reqBody := Tag{Tags: []string{"emergency", "crisis"}}
	req, _ := createTestRequest("POST", "/chat/crisis_card?region=ET&lang=EN", reqBody)
	w := httptest.NewRecorder()
	
	// Serve request
	router.ServeHTTP(w, req)
	
	// Assertions
	assert.Equal(t, http.StatusOK, w.Code)
	
	var response map[string]interface{}
	json.Unmarshal(w.Body.Bytes(), &response)
	
	// The response should have key "Crisis-card: " (with space)
	assert.NotNil(t, response["Crisis-card: "])
	assert.Equal(t, "crisis_card_content", response["Crisis-card: "])
	
}
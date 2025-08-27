package delivery

import (
	controllers "sema/Delivery/Controllers"
	routers "sema/Delivery/Routers"
	infrastructure "sema/Infrastructure"
	repository "sema/Repository"
	usecase "sema/Usecase"
)

func main(){
	// Intialize dependencies
	db := repository.InitializeDB()

	// User Dependencies
	// us_repo := repository.NewUserRepo(db)
	// us_usecase := usecase.NewUserUsecase(us_repo)
	// us_controller := controllers.NewUserController(us_usecase)

	// Chat dependencies
	chat_repo := repository.NewChatRepo(db)
	chat_ai := infrastructure.InitAIClient()
	chat_usecase := usecase.NewChatUsecase(chat_repo, chat_ai)
	chat_controller := controllers.NewChatController(chat_usecase)

	// Router
	routers.SetupRouter(chat_controller)
}
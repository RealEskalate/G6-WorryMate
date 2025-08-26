package repository

import "go.mongodb.org/mongo-driver/mongo"

type UserRepository struct {
	UserCollection *mongo.Collection
}

func NewUserRepo(db *mongo.Database) (*UserRepository){
	return &UserRepository{
		UserCollection: db.Collection("users"),
	}
}
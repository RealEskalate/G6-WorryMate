package controllers

type UserDTO struct {
	Password string  `json:"password"`
	Role     string	 `json:"role"`
	Username string  `json:"username"`
	Email    string  `json:"email"`
}
class UsersController < ApplicationController

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      render json: { username: @user.username, email: @user.email, created_at: @user.created_at, updated_at: @user.updated_at }, status: :created
    else
      render json: { errors: @user.errors.messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(:username, :email, :password)
  end
end
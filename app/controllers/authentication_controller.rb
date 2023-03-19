class AuthenticationController < ApplicationController

  def login
    @user = User.find_by(username: params[:username])

    if @user&.authenticate(params[:password])
      render json: { token: token }, status: :ok
    else
      render json: { error: 'unauthorized' }, status: :unauthorized
    end
  end

  private

  def payload
    {
      username: @user.username
    }
  end

  def exp
    2.hours.from_now
  end

  def token
    Security::JsonWebToken.encode(
      payload,
      exp
    )
  end
end
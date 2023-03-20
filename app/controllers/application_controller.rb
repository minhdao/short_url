class ApplicationController < ActionController::API

  def authorize_request
    auth_header = request.headers['Authorization']
    token = auth_header.split(' ').last

    begin
      @decoded = Security::JsonWebToken.decode(token)
      @decoded_user = User.find_by_username!(@decoded[:username])
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::DecodeError, JWT::ExpiredSignature => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end
end

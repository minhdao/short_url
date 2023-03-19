class Security::JsonWebToken

  # Default token expire time in hour
  JWT_DEFAULT_EXP = 1.freeze

  def self.encode(payload, exp = JWT_DEFAULT_EXP.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, secret_key)
  end

  def self.decode(token)
    decoded = JWT.decode(token, secret_key)[0]
    HashWithIndifferentAccess.new decoded
  end

  private

  # Can also load from .env file
  def self.secret_key
    @_secret_key ||= Rails.application.secrets.secret_key_base.to_s
  end
end
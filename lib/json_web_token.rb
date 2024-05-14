require 'jwt'


class JsonWebToken
  extend ActiveSupport::Concern
  SECRET_KEY_BASE = Rails.application.secret_key_base

  def self.jwt_encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY_BASE)
  end

  def self.jwt_decode(token)
    decoded = JWT.decode(token, SECRET_KEY_BASE)[0]
    HashWithIndifferentAccess.new(decoded)
  end
end

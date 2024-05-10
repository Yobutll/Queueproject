
class AuthenticationController < ApplicationController
  SECRET_KEY_BASE = Rails.application.secret_key_base
  skip_before_action :authenticate_request , only: [:login]
  require 'jwt'
  def login
    encrypt_password = Admin.encrypt(params[:password])
    @admin = Admin.find_by(username: params[:username], password_digest: encrypt_password)
    if @admin
      creation_time = Time.now
      expiration_time = creation_time + 24.hours # Set expiration time
      payload = { admin_id: @admin.id} 
      token = jwt_encode(payload)
      # token_decode = jwt_decode(token) 
      # puts token_decode
      token_obj = Token.new(tokenAdmin: token, admins_id: @admin.id, expiredAdmin: expiration_time)      
      if token_obj.save
        render json: { status: "Save success" ,token: token, expired: expiration_time}, status: :ok
      else
        render json: { error: 'Unable to generate token ' }, status: :unauthorized
      end
    else
      render json: { error: 'Wrong password' }, status: :unauthorized
    end
  end

  def jwt_encode(payload)
    exp = 1.minute.from_now
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY_BASE)
  end

  # def jwt_decode(token)
  #   decoded = JWT.decode(token, SECRET_KEY_BASE)[0]
  #   HashWithIndifferentAccess.new(decoded)
  # end
end

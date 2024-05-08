class AuthenticationController < ApplicationController
  require 'jwt'
  SECRET_KEY_BASE = Rails.application.secret_key_base
  skip_before_action :authenticate_request

  def login
    encrypt_password = Admin.encrypt(params[:password])
    puts encrypt_password
    @admin = Admin.find_by(username: params[:username], password_digest: encrypt_password)

    if @admin
      payload = { admin_id: @admin.id} 
      token = jwt_encode(payload)
      #token_decode = jwt_decode(token) 
      #puts token_decode
      token_obj = Token.new(tokenAdmin: token, admins_id: @admin.id)      
      if token_obj.save
        render json: { token: token }, status: :ok
        else
            render json: { error: 'ไม่สามารถสร้าง Token ได้' }, status: :unauthorized
        end
    else
      render json: { error: 'รหัสผิด' }, status: :unauthorized
    end
  end

    def self.jwt_encode(payload)
        exp = 24.hours.from_now
        payload[:exp] = exp.to_i
        JWT.encode(payload, SECRET_KEY_BASE)
    end


  def self.jwt_decode(token)
    decoded = JWT.decode(token, SECRET_KEY_BASE)[0]
    HashWithIndifferentAccess.new(decoded)
  end

end

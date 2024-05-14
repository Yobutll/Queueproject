require 'jwt'
class AuthenticationController < ApplicationController
  skip_before_action :authenticate_request 
 
  def login
    encrypt_password = Admin.encrypt(params[:password])
    @admin = Admin.find_by(username: params[:username], password_digest: encrypt_password)
    if @admin
      token_admin = Token.find_by(admins_id: @admin.id)
      if token_admin.nil? || token_admin.expired?
        payload = { admin_id: @admin.id }
        token = JsonWebToken.jwt_encode(payload)
        if token_admin.nil?
          Token.create(admins_id: @admin.id, tokenAdmin: token, expiredAdmin: Time.now + 24.hours, status: true)
        else
          token_admin.update(tokenAdmin: token, expiredAdmin: Time.now + 24.hours, status: true)
        end
      else
        token = token_admin.tokenAdmin
      end
      render json: { token: token }, status: :ok
    else
      head :unauthorized
    end
  end
  
  def logout
    # Token.destroy_all
    header = request.headers['Authorization']
    token = header.split(' ').last if header
    access_token = Token.find_by(tokenAdmin: token)
    if access_token.present?
      access_token.destroy
      render json: { status: "Token deleted" }
    else
      render json: { error: 'Token not found' }, status: 404
    end
  end


end

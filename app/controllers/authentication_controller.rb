class AuthenticationController < ApplicationController
  skip_before_action :authenticate_request 

  def login
    encrypt_password = Admin.encrypt(params[:password]) 
    @admin = Admin.find_by(username: params[:username], password_digest: encrypt_password)

    if @admin
      # Create token
      payload = { admin_id: @admin.id }
      token = JsonWebToken.jwt_encode(payload)
      Token.create(admins_id: @admin.id, tokenAdmin: token, expiredAdmin: Time.now + 1.minutes, status: true) 
      render json: { token: token }, status: :ok
    else
      head :unauthorized
    end
  end

  def logout
    header = request.headers['Authorization']
    token = header.split(' ').last if header
    access_token = Token.find_by(tokenAdmin: token)
    # If logout will destroy present token 
    if access_token.present?
      access_token.destroy
      render json: { status: "Token deleted" }
    else
      render json: { error: 'Token not found' }, status: 404
    end
  end

end
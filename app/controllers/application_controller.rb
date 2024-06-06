require 'jwt'
class ApplicationController < ActionController::API
  SECRET_KEY_BASE = Rails.application.secret_key_base
  before_action :authenticate_request

  def authenticate_request
    header = request.headers['Authorization']
    token = header.split(' ').last if header
    access_token = Token.find_by(tokenAdmin: token)
    # Check token expired and change status to false and destroy all token
    if access_token.present?
        Token.where('"expiredAdmin" < ?', Time.now).update_all(status: false)
        if  Token.where(status: false).destroy_all
          
        end
    else
      render json: { error: 'Not Authorized' }
    end
  end

  def authenticate_user_request
    header = request.headers['Authorization']
    token = header.split(' ').last if header
    decoded_token = JWT.decode(token, nil, false)
    token_admin = Token.find_by(tokenAdmin: token)
    uidLine = decoded_token.first['sub']
    if token
      user = Customer.find_by(uidLine: uidLine)
      if user || token_admin
         { user: user, token_admin: token_admin }
      else
        render json: { error: 'User doesnt exist' }, status: :unauthorized
      end  
    else
      render json: { error: 'Not Authorized' }, status: :unauthorized
    end
  end
end
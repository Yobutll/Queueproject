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

      if Time.now > access_token.expiredAdmin
        Token.where('"expiredAdmin" < ?', Time.now).update_all(status: false)
        if  Token.where(status: false).destroy_all
        end
        render json: { error: 'Token expired' }
      else
        decoded = JsonWebToken.jwt_decode(token)
        @current_user = Admin.find(decoded[:admin_id])
        # render json: { status: 'success' }
      end
    else
      render json: { error: 'Not Authorized' }
    end
  end

  # เพื่มอันนี้
  # def authen_line
  #   header = request.headers['Authorization']
  #   token = header.split(' ').last if header
  #   decoded_token = JWT.decode(token, nil, false)
  #   expiration_time = Time.at(decoded_token.first['exp'])
  #   current_time = Time.now
  #   customer = Customer.find_by(tokenLine: token)
  #   if customer.present? 
  #     if expiration_time < current_time
  #       Customer.where('"expiration_time" < ?', Time.now).destroy
  #       render json: { status: 'destros success' }
  #     else
  #       render json: { error: 'Not Authorzed' }
  #     end
  #   end  
  # end

  # def authen_queue
  #   header = request.headers['Authorization']
  #   token = header.split(' ').last if header
  #   token_admin = Token.find_by(tokenAdmin: token)
  #   token_customer = Customer.find_by(tokenLine: token)
  #   if token_admin || token_customer
  #     # render json: { status: 'success' }
  #   else
  #     render json: { error: 'Not Authorzed' }
  #   end 
  # end
  
end
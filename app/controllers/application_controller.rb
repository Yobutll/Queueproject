require 'jwt'
class ApplicationController < ActionController::API
  SECRET_KEY_BASE = Rails.application.secret_key_base
  before_action :authenticate_request
  rescue_from JWT::ExpiredSignature, with: :render_token_expired 

  def authenticate_request
    header = request.headers['Authorization']
    token = header.split(' ').last if header
    access_token = Token.find_by(tokenAdmin: token)
    if access_token.present?
      decoded = jwt_decode(token)
      @current_user = Admin.find(decoded[:admin_id])
      
    else
      render json: { error: 'Not Authorized' }, status: 401 
    end
  end


  def jwt_decode(token)
    decoded = JWT.decode(token, SECRET_KEY_BASE)[0]
    HashWithIndifferentAccess.new(decoded)
  end

  def render_token_expired
    render json: { error: 'Token expired' }, status: 401
  end

end

require 'jwt'
class ApplicationController < ActionController::API
  SECRET_KEY_BASE = Rails.application.secret_key_base
  before_action :authenticate_request

  def authenticate_request
    header = request.headers['Authorization']
    token = header.split(' ').last if header
    access_token = Token.find_by(tokenAdmin: token)
    if access_token.present?
      if Time.now > access_token.expiredAdmin
        access_token.update(status: false)
        render json: { error: 'Token expired' }, status: 401
      else
        decoded = JsonWebToken.jwt_decode(token)
        @current_user = Admin.find(decoded[:admin_id])
        # render json: { status: 'success' }
      end
    else
      render json: { error: 'Not Authorized' }, status: 401
    end
  end

end

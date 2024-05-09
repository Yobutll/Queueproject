require 'jwt'

class ApplicationController < ActionController::API
  SECRET_KEY_BASE = Rails.application.secret_key_base
  before_action :authenticate_request

  def authenticate_request
    header = request.headers['Authorization']
    token = header.split(' ').last if header
    access_token = Token.find_by(tokenAdmin: token) 
    if access_token.present?
    decoded = jwt_decode(token)
    render json: { status: 'Request success' }
    @current_user = Admin.find(decoded[:admin_id])
    else
      render json: { error: 'Not Authorized' }, status: 401 
    end
  end


  def jwt_encode(payload)
    exp = 24.hours.from_now
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY_BASE)
  end

  def jwt_decode(token)
    decoded = JWT.decode(token, SECRET_KEY_BASE)[0]
    HashWithIndifferentAccess.new(decoded)
  end

end

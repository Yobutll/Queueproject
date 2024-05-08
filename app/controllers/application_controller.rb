class ApplicationController < ActionController::API

  before_action :authenticate_request

  private 
  def authenticate_request
    header = request.headers['Authorization']
    token = header.split(' ').last if header
    access_token = Token.find_by(tokenAdmin: token) 
    if access_token.present?
    decoded = AuthenticationController.jwt_decode(token)
    @current_user = Admin.find(decoded[:admin_id])
    else
      render json: { error: 'Not Authorized' }, status: 401 
    end
  end
end

class ApplicationController < ActionController::Base
  before_action :authenticate_request

  private

  def authenticate_request
    if cookies.signed[:jwt].present?
      token = cookies.signed[:jwt]
      decoded_token = JsonWebToken.decode(token)
      if decoded_token && decoded_token[:admin_id]
        @current_admin = Admin.find(decoded_token[:admin_id])
      else
        render json: { error: 'Unauthorized' }, status: :unauthorized
      end
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  rescue JWT::DecodeError
    render json: { error: 'Unauthorized' }, status: :unauthorized
  end

  def current_admin
    @current_admin
  end
end
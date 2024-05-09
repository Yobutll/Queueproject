class ApplicationController < ActionController::Base
  # before_action :authenticate_request, except: [:create] # Exclude the create action from authentication

  # private

  # def authenticate_request # Check if the request is authenticated
  #   if cookies.signed[:jwt].present? # Check if the cookie is present
  #     token = cookies.signed[:jwt] # Get the token from the cookie
  #     decoded_token = JsonWebToken.decode(token) # Decode the token
  #     if decoded_token == decoded_token[:admin_id] # Check if the token is valid
  #       @current_admin == Admin.find(decoded_token[:admin_id]) # Find the user by the token
  #     else 
  #       render json: { error: 'token is invalid' }, status: :unauthorized # Return unauthorized if the token is invalid
  #     end
  #   else
  #     render json: { error: 'cookie is not present' }, status: :unauthorized # Return unauthorized if the cookie is not present
  #   end
  # rescue JWT::DecodeError
  #   render json: { error: 'cannot be decoded' }, status: :unauthorized # Return unauthorized if the token cannot be decoded
  # end

  # def current_admin # Get the current user
  #   @current_admin # Return the current user
  # end
end

class AdminsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_admin, only: [:show, :update]

  # POST /admins
  def index
    admin = Admin.all # Get all users
    render json: admin # Return all users
  end

  def show
    admin = Admin.find_by(username: params[:username]) # Find user by username
    if admin 
      token = JsonWebToken.encode(admin_id: @admin.id)
      save_token_to_database(admin.id, token)
      render json: {location: admin, token: token}
    else
      render json: { error: 'Invalid username or password' }, status: :not_found
    end

  end

  def create
    @admin = Admin.new(admin_params)
    if @admin.save # Save to database
      creation_time = Time.now
      expiration_time = creation_time + 24.hours # Set expiration time
      token = JsonWebToken.encode(admin_id: @admin.id, exp: expiration_time.to_i) # Generate token
      save_token_to_database(@admin.id, token, expiration_time) # Save token, expired and admin_id to the tokens table
      cookies.signed[:jwt] = { value:  token, httponly: true } # Set cookie httponly
      render json: {status: :created, location: @admin, token: token, expires_at: expiration_time} # Return token
    else
      # Password is incorrect or user not found
      render json: { error: 'Invalid username or password' }, status: :unauthorized
    end
  end


  #Check login by compare encrypted password that user input with password_digest
  def check_login
    encrypt_password = Admin.encrypt(params[:password_digest])
    @admin = Admin.find_by(username: params[:username], password_digest: encrypt_password)
    if @admin
      token = JsonWebToken.encode(admin_id: @admin.id)
      save_token_to_database(@admin.id, token)
      cookies.signed[:jwt] = { value:  token, httponly: true }
      render json: {location: @admin, token: token}

    else
      # Password is incorrect or user not found
      render json: { error: 'Invalid username or password' }, status: :unauthorized
    end
  end

  # PATCH/PUT /admins/1
  def update
    if @admin.update(admin_params)
      render json: @admin
    else
      render json: @admin.errors, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin
      @admin = Admin.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def admin_params
      params.require(:admin).permit(:username, :password_digest)
    end

    # Save token and admin_id to the tokens table
    def save_token_to_database(admin_id, token, expiration_time)
      Token.create(admins_id: admin_id, tokenAdmin: token, expiredAdmin: expiration_time) # Save token and admin_id to the tokens table
    end
end
  # POST /admins.json
  # PATCH/PUT /admins/1
  # PATCH/PUT /admins/1.json
  # DELETE /admins/1
  # DELETE /admins/1.json
  # GET /admins
  # GET /admins.json
  # GET /admins/1
  # GET /admins/1.json

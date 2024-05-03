class AdminsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_admin, only: [:show, :update]

  # POST /admins
  def index
    admin = Admin.all
    render json: admins
  end

  def show
    admin = Admin.find_by(username: params[:username])
    if admin 
      render json: admin
    else
      render json: { error: 'Invalid username or password' }, status: :not_found
    end

  end

  def create
    edmin = Admin.encrypt(admin_params[:password_digest])
    puts edmin

    @admin = Admin.new(admin_params)
    if @admin.save
      token = JsonWebToken.encode(admin_id: @admin.id)
      cookies.signed[:jwt] = { value:  token, httponly: true }
      render json: {status: :created, location: @admin, token: token}
    else
      # Password is incorrect or user not found
      render json: { error: 'Invalid username or password' }, status: :unauthorized
    end
  end

  def check_login
    encrypt_password = Admin.encrypt(params[:password_digest])
    @admin = Admin.find_by(username: params[:username], password_digest: encrypt_password)
    if @admin
      render json: @admin
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
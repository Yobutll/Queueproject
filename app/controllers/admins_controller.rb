class AdminsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]
  before_action :redirect_logged_in_users, except: [:login, :new, :create]

  # GET /admins
  # GET /admins.json
  def index
    @admins = Admin.all
  end

  # GET /admins/1
  # GET /admins/1.json
  def show
  end

  # POST /admins
  # POST /admins.json
  def create
    admin = Admin.find_by(username: params[:username])
    if admin&.authenticate(params[:password])
      token = JsonWebToken.encode(admin_id: admin.id)
      cookies.signed[:jwt] = { value:  token, httponly: true }
      render json:{token: token, admin: admin}
      puts "success"
      puts token
    else
      render json: { error: 'Invalid user_name or password' }, status: :unauthorized
    end
  end

  # PATCH/PUT /admins/1
  # PATCH/PUT /admins/1.json
  def update
    if @admin.update(admin_params)
      render :show, status: :ok, location: @admin
    else
      render json: @admin.errors, status: :unprocessable_entity
    end
  end

  # DELETE /admins/1
  # DELETE /admins/1.json
  def destroy
    cookies.delete(:jwt)
    redirect_to login_path
  end

  def login
    
  end 
  private

  def authenticate_admin!
    redirect_to login_path unless cookies.signed[:jwt].present?
  end

  def redirect_logged_in_users
    if cookies.signed[:jwt].present?
      redirect_to login_path
    end
  end
end

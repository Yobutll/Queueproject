class AdminsController < ApplicationController
  #skip_before_action :authenticate_request, only: [:create, :check_login]
  #before_action : set_admin, only: [:show, :destroy, :create, :update]

  # POST /admins
  def index
    @admin = Admin.all # Get all users
    render json: @admin # Return all users
  end

  def show
    render json: @admin
  end

  def create
    @admin = Admin.new(admin_params)
    if @admin.save
      render json: {status: :created, location: @admin}
    else
      render json: @admin.errors, status: :unprocessable_entity
    end

  end


  #Check login by compare encrypted password that user input with password_digest
  #def check_login
  #  encrypt_password = Admin.encrypt(params[:password_digest])
  #  @admin = Admin.find_by(username: params[:username], password_digest: encrypt_password)
  #  if @admin
  #    render json: {location: @admin}
  #
  #  else
  #    # Password is incorrect or user not found
  #    render json: { error: 'Invalid username or password' }, status: :unauthorized
  #  end
  #end

  # PATCH/PUT /admins/1
  def update
    if @admin.update(admin_params)
      render json: @admin.errors.full_messages
    else
      render json: @admin.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @admin.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin
      @admin = Admin.find(params[:id])
    end

    def admin_params 
      params.permit(:username, :password)
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

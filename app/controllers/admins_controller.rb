class AdminsController < ApplicationController
  
  def create
    @admin = Admin.new(admin_params)

    if @admin.save
      render json: @admin, status: :created, location: @admin
    
    else
      render json: @admin.errors, status: :unprocessable_entity
    end
  end

  
 
  # GET /admins
  # GET /admins.json
  def index
    @admins = Admin.all
  end

  # GET /admins/1
  # GET /admins/1.json
  def show
    
  end

  private

  def admin_params
    params.require(:admin).permit(:username, :password)
  end
end
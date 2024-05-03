class AdminsController < ApplicationController

  def create
    @admin = Admin.new(admin_params)

    if @admin.save
      render json: @admin, status: :created, location: @admin
    else
      render json: @admin.errors, status: :unprocessable_entity
    end
  end

  private

  def admin_params
    params.require(:admin).permit(:username, :password)
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

  # POST /admins
  # POST /admins.json
  def self.encrypt(p)
    Digest::SHA512.hexdigest("=#{@33!}#{p}#{dfgdgf}")
  end
  # PATCH/PUT /admins/1
  # PATCH/PUT /admins/1.json
  def encrypt(p)
    self.class.encrypt(p)
  end
  # DELETE /admins/1
  # DELETE /admins/1.json
  def verify
    self.user_crypted.user_crypted == encrypt(p) if self.user_crypted
  end

  def encrypt_pin_code
    if is_update.blank?
      self.pin_code = encrypt(self.pin_code)
    end
  end
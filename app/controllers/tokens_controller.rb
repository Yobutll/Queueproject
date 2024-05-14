class TokensController < ApplicationController
  skip_before_action :authenticate_request, only: [:Admin_session]
  before_action :set_token, only: %i[ show update destroy ]

  # GET /tokens
  # GET /tokens.json
  def index
    @tokens = Token.all
    render json: @tokens
  end

  def self.Admin_session
    token = Token.select(:tokenAdmin, :admins_id)
    render json: token
  end

  # GET /tokens/1
  # GET /tokens/1.json
  def show
    tokenAdmin = Token.find_by(token_id: params[:token_id])
    if tokenAdmin
      render json: {location: @token, token: tokenAdmin}
    else
      render json: { error: 'Invalid token' }, status: :not_found
    end
  end

  # POST /tokens
  # POST /tokens.json
  def create
    @token = Token.new(token_params)
    if @token.save
      render :show, status: :created, location: @token
    else
      render json: @token.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tokens/1
  # PATCH/PUT /tokens/1.json
  def update
    if @token.update(token_params)
      render :show, status: :ok, location: @token
    else
      render json: @token.errors, status: :unprocessable_entity
    end
  end

  # DELETE /tokens/1
  # DELETE /tokens/1.json
  def destroy
    @token.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
  def set_token
    @token = Token.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def token_params
    params.require(:queue_user).permit(:customer_id, :admin_id, :expiredAdmin, :expiredLine, :tokenAdmin, :tokenLineID)
  end
end
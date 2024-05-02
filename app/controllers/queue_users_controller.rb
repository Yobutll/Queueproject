class QueueUsersController < ApplicationController
  skip_before_action :verify_authenticity_token

  # GET /queue_users
  # GET /queue_users.json
  def index
    @queue_users = QueueUser.all
    render json: @queue_users
  end

  # GET /queue_users/1
  # GET /queue_users/1.json
  def show
    queue = QueueU.find_by_id(params[:id])
    if queue
      render json: queue
    else
      render json: { error: 'Queue not found' }, status: :not_found
    end
  end

  # POST /queue_users
  # POST /queue_users.json
  def create
    queue_u = QueueU.new(queue_u_params)

    if queue_u.save
      render json:queue_u , status: :created
      print"success"
    else
      render json: queue_u.errors, status: :unprocessable_entity
      print"fail"
    end
  end

  # PATCH/PUT /queue_users/1
  # PATCH/PUT /queue_users/1.json
  def update
    queue_u = QueueU.find_by_id(params[:id])
    if queue_u.update(queue_u_params)
      render json:queue_u, status: :ok
    else
      render json: queue_u.errors
    end
  end

  # DELETE /queue_users/1
  # DELETE /queue_users/1.json
  def destroy
    queue = QueueU.find_by_id(params[:id])
    if queue.destroy
      render json: { message: 'Queue was successfully destroyed' }
    else
      render json: { error: 'Queue not found' }, status: :not_found
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_queue_user
      @queue_user = QueueUser.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def queue_user_params
      params.fetch(:queue_user, {})
    end
end

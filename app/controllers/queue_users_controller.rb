class QueueUsersController < ApplicationController
  skip_before_action :authenticate_request 
  # GET /queue_users
  # GET /queue_users.json

  def index
    date = params[:date]
    if date.nil?
      @queue_users = QueueUser.all
      
    else
      date = Date.parse(date) # Convert the date string to a Date object
      @queue_users = QueueUser.where("DATE(created_at) = ?", date)
    end
    render json: @queue_users
  end

  # GET /queue_users/1
  # GET /queue_users/1.json
  def show
    cus_id = params[:id]
    queue = QueueUser.where(customer_id: cus_id).where(cusStatus: ["1", "2"]).first
    if queue
      q_count = QueueUser.where("created_at < ?", queue.created_at).where(cusStatus: ["1", "2"]).count
      render json: { queue_count: q_count, queue:queue}
    else
      render json: { error: 'Queue not found' }, status: :not_found
    end
  end

  # POST /queue_users
  # POST /queue_users.json
  def create
    if queue_user_params[:customer_id].present?
      customer = QueueUser.where(customer_id: queue_user_params[:customer_id]).where(cusStatus: ["1", "2"])
      if customer.present?
        render json: { error: '1 Queue per 1 acc' }, status: :unprocessable_entity
      else
        queue_u = QueueUser.new(queue_user_params)
        if queue_u.save
          render json: queue_u, status: :created
        else
          render json: queue_u.errors, status: :unprocessable_entity
        end
      end
    else
      render json: { error: 'customer_id is required' }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /queue_users/1
  # PATCH/PUT /queue_users/1.json
  def update
    queue_u = QueueUser.find_by_id(params[:id])
    if queue_u.update(queue_user_params)
      render json:queue_u, status: :ok
    else
      render json: queue_u.errors
      puts queue_u.error.full_messages
    end
  end

  # DELETE /queue_users/1
  # DELETE /queue_users/1.json
  def destroy
    queue = QueueUser.find_by_id(params[:id])
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
    params.require(:queue_user).permit(:cusName, :cusPhone, :cusSeat, :customer_id, :cusStatus ,:qNumber)
  end
end

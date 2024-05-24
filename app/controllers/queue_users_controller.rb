class QueueUsersController < ApplicationController
  skip_before_action :authenticate_request , only: [:create, :update, :show, :index, :destroy]
  # GET /queue_users
  # GET /queue_users.json
  # GET /queue_users?status=3

  
  def index
    date = params[:date]
    qstatus = params[:status]
    queue_1_2 = QueueUser.where(cusStatus: ["1", "2"])
    queue_3_0 = QueueUser.where(cusStatus: ["3", "0"])
    if date.nil?
      if qstatus == "1"
        queue_1 = QueueUser.where(cusStatus: ["1"])
        render json: queue_1 
      elsif qstatus == "2"
        queue_2 = QueueUser.where(cusStatus: ["2"])
        render json: queue_2
      elsif qstatus == "all"
        render json: queue_1_2
      else
        render json: queue_3_0 
      end
    else
      date = Date.parse(date) # Convert the date string to a Date object
      queue_1_2 = QueueUser.where("DATE(created_at) = ?", date)
      queue_3_0 = QueueUser.where("DATE(created_at) = ?", date)
      render json: queue_3_0 
    end
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
        queue_u = QueueUser.create(queue_user_params)
        ActionCable.server.broadcast('QueueManagmentChannel', {action: 'create', queue: queue_u}) 
        
        if queue_u
          render json: queue_u, status: :created
        else
          render json: "queue not save", status: :unprocessable_entity
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
    if !["0", "3"].include?(queue_u.cusStatus) 
      if queue_u.update(queue_user_params)
      ActionCable.server.broadcast('QueueManagmentChannel', {action: 'update', queue: queue_u})
        render json:queue_u, status: :ok
      else
        queue_u.notify_if_queue_called_again
      end
    else
      render json: "คิวนี้เสร็จสิ้นไปแล้ว", status: :unprocessable_entity
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

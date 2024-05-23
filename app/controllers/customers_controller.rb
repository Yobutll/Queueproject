class CustomersController < ApplicationController
  #skip_before_action :verify_authenticity_token
  # GET /customers
  # GET /customers.json
  skip_before_action :authenticate_request , only: [:create, :index]
 

  def index
    uid_line = params[:uidLine]
    customer = Customer.find_by(uidLine: uid_line)
    queueActive = QueueUser.where(customer_id: customer.id).where(cusStatus: ["1", "2"]).first
    puts customer
    if customer.present? 
      if queueActive.present?
        render json: {exist: 1 , customer: customer, queueActive: true}
      else
        render json: {exist: 1 , customer: customer, queueActive: false}
      end
    else
      render json: {exist: 0}
    end
  end

  # GET /customers/1
  # GET /customers/1.json
  def show
    customer = Customer.find_by_id(params[:id])
    if customer
      render json: customer
    else
      render json: { error: 'Customer not found' }, status: :not_found
    end
  end

  # POST /customers
  # POST /customers.json
  def create
    uid_line = customer_params[:uidLine]
    customers = Customer.find_by(uidLine: uid_line)
    # queueNew = customer_params[:queueNew]
    if customers.present?
      render json: { error: 'Customer already exists' }, status: :unprocessable_entity
    else
      customer = Customer.new(uidLine: uid_line)
      customer.queueNew = customer_params[:queueNew]
      if customer.save 
        render json: customer, status: :created
      else
        render json: customer.errors, status: :unprocessable_entity
      end
    end
  end


  # PATCH/PUT /customers/1
  # PATCH/PUT /customers/1.json
  def update
    customer = Customer.find_by_id(params[:id])
    if customer.update(customer_params)
      
      render json:customer , status: :ok
    else
      render json: @customer.errors, status: :unprocessable_entity
    end
  end

  # DELETE /customers/1
  # DELETE /customers/1.json
  
  def destroy
      customer = Customer.find_by_id(params[:id])
    if customer.destroy
      render json: { message: 'Customer was successfully destroyed' }
    else
      render json: { error: 'Customer not found' }, status: :not_found
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_customer
      @customer = Customer.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def customer_params
      params.require(:customer).permit(:uidLine, queueNew: [:cusName, :cusPhone, :cusSeat])
    end
end
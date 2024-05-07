class CustomersController < ApplicationController
  skip_before_action :verify_authenticity_token
  # GET /customers
  # GET /customers.json

  def index
    customers = Customer.all
    render json: customers
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
    queueNew = params[:queueNew]
    customer = Customer.new(customer_params.except(:queueNew))
    if customer.save
      customer.queueNew = queueNew 
      customer.save_queue
      render json: customer, status: :created
      
    else
      render json: customer.errors, status: :unprocessable_entity
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
class CustomersController < ApplicationController
  skip_before_action :verify_authenticity_token
  # GET /customers
  # GET /customers.json
  def index
    customers_with_queues = Customer.joins(:queue_u).select('customers.*, queue_us.queue_number, queue_us.status_id, queue_us.queue_finish_at')
    if customers_with_queues.any?
      puts "Join between Customer and QueueU has been successful."
    else
      puts "No records found after joining Customer and QueueU."
    end
    @customers = Customer.all
    render json: customers_with_queues
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
    customer = Customer.new(customer_params)

    if customer.save
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
      params.fetch(:customer, {})
    end
end
class CustomersController < ApplicationController
  #skip_before_action :verify_authenticity_token
  # GET /customers
  # GET /customers.json
  skip_before_action :authenticate_request

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
    uid_line = customer_params[:uidLine]
    customer = Customer.find_by(uidLine: uid_line)
    if customer.present?
      render json: { error: 'Customer already exists' }, status: :unprocessable_entity
    else
      customer = Customer.new(customer_params)
      if customer.save
        creation_time = Time.now
        expiration_time = creation_time + 24.hours # Set expiration time
      # Access token parameters directly from customer_params
        token_line_id = customer_params[:tokenNew].first[:tokenLineID]
      # Assuming you have defined a has_many association in your Customer model
      # If not, replace 'tokens' with the appropriate association name
        token = customer.tokens.build(tokenLineID: token_line_id, expiredLine: expiration_time)
        if token.save
          render json: { status: :created, location: customer, token: token.tokenLineID, expires_at: expiration_time }
        else
          render json: { error: 'Failed to save token' }, status: :unprocessable_entity
        end
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
      params.require(:customer).permit(:uidLine, queueNew: [:cusName, :cusPhone, :cusSeat], tokenNew: [:tokenLineID])
    end

    
end
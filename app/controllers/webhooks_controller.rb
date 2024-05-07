class WebhooksController < ApplicationController
    skip_before_action :verify_authenticity_token
    
    def receive
        event = Stripe::Event.construct_from(params.to_unsafe_h)
    
        # Handle the event
        begin
          case event.type
          when 'payment_intent.succeeded'
            handle_payment_succeeded(event.data.object)
          when 'payment_intent.payment_failed'
            handle_payment_failed(event.data.object)
          else
            raise "Unhandled event type: #{event.type}"
          end
        rescue StandardError => e
          render json: { error: e.message }, status: :unprocessable_entity
        end
    
        render json: { message: 'Webhook received successfully' }, status: :ok
      end
    
      private
    
        def handle_payment_succeeded(payment_intent)
            # Find the user associated with the payment
            user = User.find_by(stripe_customer_id: payment_intent.customer)
    
            # Check if the payment covers any outstanding invoices
            invoices = user.invoices.unpaid
            invoices.each do |invoice|
                if invoice.amount_due <= payment_intent.amount_received
                invoice.update(status: 'paid', paid_at: Time.now)
                payment_intent.amount_received -= invoice.amount_due
                end
            end
    
            # Create a new payment record
            payment = Payment.create(
                user: user,
                amount: payment_intent.amount_received,
                payment_method: payment_intent.payment_method,
                payment_intent_id: payment_intent.id,
                status: payment_intent.status,
                paid_at: payment_intent.created
            )
    
            # Send a confirmation email to the user
            UserMailer.payment_received(user, payment).deliver_later
            rescue => e
             Rails.logger.error("Error handling payment failed webhook: #{e}")
        end
    
        def handle_payment_failed(payment_intent)
            # Find the user associated with the payment
            user = User.find_by(stripe_customer_id: payment_intent.customer)
    
            # Handle any unpaid invoices
            invoices = user.invoices.unpaid
            invoices.each do |invoice|
                invoice.update(status: 'failed', failed_at: Time.now)
            end
    
            # Create a new payment record
            payment = Payment.create(
                user: user,
                amount: payment_intent.amount_received,
                payment_method: payment_intent.payment_method,
                payment_intent_id: payment_intent.id,
                status: payment_intent.status,
                failed_at: payment_intent.created
            )
    
            # Send a notification email to the user
            UserMailer.payment_failed(user, payment).deliver_later
            rescue => e
             Rails.logger.error("Error handling payment failed webhook: #{e}")
        end
end

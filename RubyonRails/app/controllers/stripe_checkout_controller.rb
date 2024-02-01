class StripeCheckoutController < ApplicationController
    before_action :set_stripe_api_key, only: [:create]
    def create
      discount_code = params[:discount_code]
    
      # Prepare the discounts array if a discount code is provided
      discounts = discount_code.present? ? [{coupon: discount_code}] : []
      
      idempotency_key = "setup_#{SecureRandom.hex(15)}_#{Time.now.to_i}"
    
      @session = Stripe::Checkout::Session.create({
        payment_method_types: ['card'],
        line_items: [{
          price: 'price_1ObIdZEdjXO5pqxuHxTg7lcC', # Replace with the actual price ID from Stripe
          quantity: 1,
        }],
        mode: 'subscription',
        success_url: success_stripe_payment_url(host: request.base_url) + '?session_id={CHECKOUT_SESSION_ID}',
        cancel_url: failure_stripe_payment_url(host: request.base_url),
        # Include the discounts array in the session creation
        allow_promotion_codes: true,  
      }, {
        idempotency_key: idempotency_key
      })
    
      respond_to do |format|
        format.js # Render create.js.erb to redirect to Stripe Checkout
      end
    end
    

    def set_stripe_api_key
        Stripe.api_key = 'sk_test_51OXZ5bEdjXO5pqxuePO6DT10pZtW1Lr23vxeUFw1Kxwc6cucGy5RO9cBe7g7eGnNJSuf7Rwrbrg7eTNibZMWsmOR00ll5PAxeH'
    end
    def success
        # Redirect or render success message
      end  
    def failure
        redirect_to sign_in, flash[:failure] = "Failed to complete transaction."
    # Redirect or render success message
    end  

end
  
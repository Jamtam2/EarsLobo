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
          price: ENV['PRICE_ID'], # Replace with the actual price ID from Stripe
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
        Stripe.api_key = ENV['API_KEY_TEST']
    end
    def success
      session_id = params[:session_id]
      session = Stripe::Checkout::Session.retrieve(session_id)

      # Assuming you have a method `generate_license_key` implemented
      # license_key = generate_license_key
      license_key = SecureRandom.hex(15)

      # Assuming `Key` is your model for storing license keys info
      Key.create!(
        activation_code: license_key,
        email: session.customer_details.email,
        customer_id: session.customer,
        expiration: 1.year.from_now,
        used: false
      )

      # Send the license key to the user's email
      UserMailer.license_key_purchase(session.customer_details.email, license_key).deliver_now

      
      flash[:notice] = 'Please check your email for your verification key.'

      # Redirect or render success message
      end  
    def failure
        redirect_to sign_in, flash[:failure] = "Failed to complete transaction."
    # Redirect or render success message
    end  

end
  

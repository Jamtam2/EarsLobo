class WebhooksController < ApplicationController
    skip_before_action :verify_authenticity_token, only: [:stripe]
  
    def stripe
      payload = request.body.read
      sig_header = request.env['HTTP_STRIPE_SIGNATURE']
      event = nil
  
      begin
        event = Stripe::Webhook.construct_event(
          payload, sig_header, '[WEBHOOK KEY]'
        )
      rescue JSON::ParserError, Stripe::SignatureVerificationError => e
        head :bad_request
        return
      end
  
      case event['type']
      when 'checkout.session.completed'
        session = event['data']['object']
        handle_checkout_session(session)
      end
  
      head :ok
    end
  
    private
  
    def handle_checkout_session(session)
      # Retrieve customer email and other necessary information
      customer_email = session.customer_details.email
      stripe_customer_id = session.customer
  
      # Generate a license key
      license_key = generate_license_key
  
      # Create and store the license key associated with the Stripe customer ID
      Key.create!(
        activation_code: license_key,
        email: customer_email,
        customer_id: stripe_customer_id,
        expiration: 1.year.from_now,
        used: false
      )
  
      # Send the license key to the user's email
      UserMailer.license_key_purchase(customer_email, license_key).deliver_now
    end
  
    def generate_license_key
      SecureRandom.hex(15) # Generates a random hex string
    end
  end
  
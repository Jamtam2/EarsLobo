class WebhooksController < ApplicationController
    skip_before_action :verify_authenticity_token, only: [:stripe]
  
    def stripe
      payload = request.body.read
      sig_header = request.env['HTTP_STRIPE_SIGNATURE']
      event = nil
  
      begin
        event = Stripe::Webhook.construct_event(
          payload, sig_header, 'whsec_e99ecdf451f138850620d27b2c0427bd2272381ba3c32a3087524417ee77ceef'
        )
      rescue JSON::ParserError, Stripe::SignatureVerificationError => e
        head :bad_request
        return
      end
  
      case event['type']
      when 'checkout.session.completed'
        session = event['data']['object']
        handle_checkout_session(session)
      when 'invoice.payment_succeeded'
        invoice = event['data']['object']
        handle_invoice_payment(invoice)
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
    
    def handle_invoice_payment(invoice)
        # Retrieve the Stripe customer ID from the invoice object
        stripe_customer_id = invoice.customer
      
        # Find the associated license key by Stripe customer ID
        key = Key.find_by(customer_id: stripe_customer_id)
      
        # Check if a key exists and extend its expiration if it does
        if key && key.expiration
          key.update(expiration: key.expiration + 1.year)
        end
      end
      

  end
  
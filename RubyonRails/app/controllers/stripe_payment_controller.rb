require 'stripe'

class StripePaymentController < ApplicationController

  before_action :check_moderator_role
  before_action :set_stripe_api_key


  def initialize_payment_setup
    customer = Stripe::Customer.create(email: current_user.email)
    current_user.update(stripe_customer_id: customer.id)

    # Generate a unique idempotency key
    idempotency_key = "setup_#{current_user.id}_#{Time.now.to_i}"

    @session = Stripe::Checkout::Session.create({
      payment_method_types: ['card'],
      customer: customer.id,
      mode: 'setup',
      success_url: success_stripe_payment_url(host: request.base_url) + '?session_id={CHECKOUT_SESSION_ID}',
      cancel_url: failure_stripe_payment_url(host: request.base_url),
    }, {
      idempotency_key: idempotency_key
    })

    render json: { session_id: @session.id }
  end

  def initialize_payment
    customer = Stripe::Customer.create(email: current_user.email)

    # Generate a unique idempotency key
    idempotency_key = "payment_#{current_user.id}_#{Time.now.to_i}"

    @session = Stripe::Checkout::Session.create({
      payment_method_types: ['card'],
      line_items: [{
                     name: "License",
                     description: "One time client test",
                     amount: 500, # $5.00, amount in cents
                     currency: 'usd',
                     quantity: 1
                   }],
      success_url: success_stripe_payment_url(host: request.base_url),
      cancel_url: failure_stripe_payment_url(host: request.base_url),
    }, {
      idempotency_key: idempotency_key
    })

    render json: { session_id: @session.id }
  end

  def process_payment
    @charge = Stripe::Customer.retrieve(
      'Customer_id',
      { stripe_acount: 'value here'}
    )
    @charge.capture # Uses the same account
  end

  def apply_discount
  end

  def webhook
    event = nil

    begin
      sig_header = require.env['HTTP_STRIPE_SIGNATURE']
      payload = request.body.read
      secret = '[API KEY]'
      event = Stripe::Webhook.construct_event(payload, sig_header, secret)
    rescue JSON::ParseError, Stripe::SignatureVerificationError => e
    #   Invalid payload signature
    head :bad_requests
    return
    end

    # Handle event types (e.g., payment_intent.succeeded, payment_intent.failed)
  end

  def success

  end

  def failure
  end

  private

  def check_moderator_role
    unless current_user&.local_moderator?
      redirect_to root_path, alert: "You are not authorized to perform this action."
    end
  end

  def set_stripe_api_key
    Stripe.api_key = '[API KEY]'
  end
end

class GlobalModeratorsDashboardController < ApplicationController
    before_action :verify_global_moderator
    before_action :set_stripe_api_key

  
    def index
      # Dashboard view
        # @keys = Key.all.order(created_at: :desc)
        @keys = Key.where(created_by_id: current_user.id).order(created_at: :desc)

        @discounts = Discount.all.order(created_at: :desc)

    end
  
    def create_discount
      discount = Discount.new(discount_params)
    
      if discount.save
        # Create a Stripe coupon
        stripe_coupon = Stripe::Coupon.create({
          id: discount.code, # Use your discount code as the ID for easy reference
          percent_off: discount.percentage_off,
          duration: 'once', # or 'repeating' or 'forever', depending on your needs
          # For 'repeating', you should also specify 'duration_in_months'
        })
    
        promotion_code = Stripe::PromotionCode.create({
          coupon: stripe_coupon.id,
          code: discount.code,  # This is the code users will enter at checkout
        })
        redirect_to global_moderators_dashboard_index_path, notice: 'Discount created successfully.'
      else
        redirect_to global_moderators_dashboard_index_path, alert: discount.errors.full_messages.to_sentence
      end
    rescue Stripe::StripeError => e
      # Handle Stripe errors (e.g., invalid parameters or API errors)
      redirect_to global_moderators_dashboard_index_path, alert: "Stripe error: #{e.message}"
    end
    
    
    def destroy_discount
      discount = Discount.find(params[:id])
    
      begin
        # Find and deactivate the Stripe promotion code associated with the discount
        promotion_codes = Stripe::PromotionCode.list({coupon: discount.code})
        promotion_codes.data.each do |promo_code|
          Stripe::PromotionCode.update(
            promo_code.id,
            {active: false}
          )
        end
    
        # After deactivating the promotion code, delete the discount from your database
        discount.destroy
        redirect_to global_moderators_dashboard_index_path, notice: 'Discount and associated Stripe promotion code deactivated successfully.'
      rescue Stripe::StripeError => e
        # Handle Stripe errors (e.g., promotion code not found or API errors)
        redirect_to global_moderators_dashboard_index_path, alert: "Stripe error: #{e.message}"
      rescue
        # Handle other errors, such as the discount not found in your database
        redirect_to global_moderators_dashboard_index_path, alert: 'Error deleting discount.'
      end
    end
    
    

    
      def create_key
        key = Key.new(activation_code: generate_unique_activation_code, 
                  license_type: key_params[:license_type], 
                  used: false, 
                  expiration: Time.zone.now + 1.year,
                  created_by_id: current_user.id) # Assign the key to deborah to only show the keys she's generated.

    
        if key.save
          redirect_to global_moderators_dashboard_index_path, notice: 'License key created successfully.'
        else
          redirect_to global_moderators_dashboard_index_path, alert: key.errors.full_messages.to_sentence
        end
      end
    
  
    private

    def discount_params
    params.require(:discount).permit(:code, :percentage_off)
    end

    def key_params
    params.require(:key).permit(:license_type)
    end

    def generate_unique_activation_code
    loop do
        code = SecureRandom.hex(10) # adjust the length as needed
        break code unless Key.exists?(activation_code: code)
    end
    end

  
    def verify_global_moderator
           # Ensure the user is a local moderator
        @user = current_user
        puts "DEBUG: USER CUSTOMER ID: #{current_user.inspect}"
        
        redirect_to(root_url) unless @user.global_moderator?
      # Logic to verify if the current user is a global moderator
    end
    def set_stripe_api_key
      Stripe.api_key = '[API_KEY]'
  end
end

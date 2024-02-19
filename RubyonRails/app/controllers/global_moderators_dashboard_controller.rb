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
        begin
          # Check if the Stripe coupon exists
          stripe_coupon = begin
                            Stripe::Coupon.retrieve(discount.code)
                          rescue Stripe::InvalidRequestError
                            # Coupon does not exist, create a new one
                            Stripe::Coupon.create({
                              id: discount.code,
                              percent_off: discount.percentage_off,
                              duration: 'once',  # Adjust as needed
                              max_redemptions: discount.redemption_quantity,
                              redeem_by: discount.expiration_date
                            })
                          end
    
          # Handle promotion codes
          promotion_codes = Stripe::PromotionCode.list({coupon: discount.code})
          if promotion_codes.data.empty?
            # No existing promotion codes, create a new one
            Stripe::PromotionCode.create({
              coupon: stripe_coupon.id,
              code: discount.code,
            })
          else
            # Reactivate existing promotion codes if any are inactive
            promotion_codes.data.each do |promo_code|
              Stripe::PromotionCode.update(promo_code.id, {active: true}) unless promo_code.active
            end
          end
    
          redirect_to global_moderators_dashboard_index_path, notice: 'Discount created/updated successfully.'
        rescue Stripe::StripeError => e
          # Rollback discount creation in your system if Stripe operation fails
          discount.destroy
          redirect_to global_moderators_dashboard_index_path, alert: "Stripe error: #{e.message}"
        end
      else
        redirect_to global_moderators_dashboard_index_path, alert: discount.errors.full_messages.to_sentence
      end
    end
    

    
    
    def destroy_discount
      discount = Discount.find(params[:id])
    
      begin
        # Attempt to find and deactivate the Stripe promotion code associated with the discount
        promotion_codes = Stripe::PromotionCode.list({coupon: discount.code})
        promotion_codes.data.each do |promo_code|
          Stripe::PromotionCode.update(promo_code.id, {active: false})
        end
      rescue Stripe::InvalidRequestError => e
        # If the specific error message indicates "No such coupon", proceed with deletion
        if e.message.include?("No such coupon")
          Rails.logger.info "Stripe coupon not found for discount code #{discount.code}, proceeding with deletion."
        else
          # If the error is due to another issue, re-raise it to be handled by the next rescue block
          raise
        end
      rescue Stripe::StripeError => e
        # Handle other Stripe errors without deleting the discount
        redirect_to global_moderators_dashboard_index_path, alert: "Stripe error: #{e.message}"
        return  # Return early to avoid attempting to delete the discount
      end
    
      # Delete the discount from your database, regardless of Stripe coupon existence
      discount.destroy
      redirect_to global_moderators_dashboard_index_path, notice: 'Discount deleted successfully.'
    rescue => e
      # Handle other errors, such as the discount not found in your database
      redirect_to global_moderators_dashboard_index_path, alert: 'Error deleting discount: #{e.message}'
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

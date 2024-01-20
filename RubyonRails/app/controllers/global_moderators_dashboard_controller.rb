class GlobalModeratorsDashboardController < ApplicationController
    before_action :verify_global_moderator
  
    def index
      # Dashboard view
        # @keys = Key.all.order(created_at: :desc)
        @keys = Key.where(created_by_id: current_user.id).order(created_at: :desc)

        @discounts = Discount.all.order(created_at: :desc)

    end
  
    def create_discount
        discount = Discount.new(discount_params)
        if discount.save
          redirect_to global_moderators_dashboard_index_path, notice: 'Discount created successfully.'
        else
          redirect_to global_moderators_dashboard_index_path, alert: discount.errors.full_messages.to_sentence
        end
    end
    
    def destroy_discount
        discount = Discount.find(params[:id])
        discount.destroy
        redirect_to global_moderators_dashboard_index_path, notice: 'Discount deleted successfully.'
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
  
end

# app/controllers/billing_dashboard_controller.rb

class BillingDashboardController < ApplicationController
    before_action :set_local_moderator
    before_action :set_stripe_api_key, only: [:customer_portal]
    
  
    def index

      @current_month_tests = current_tests
      @previous_tests = previous_tests

    end

    def customer_portal
      # Ensure you have set the Stripe.api_key correctly
      portal_session = Stripe::BillingPortal::Session.create({
        customer: @user.stripe_customer_id,
        # url: "https://billing.stripe.com/p/login/test_14k00d2Drdoic246oo",
        return_url: billing_dashboard_index_url # You can set this to the URL you want users to return to after they're done in the portal
      })
  
      redirect_to portal_session.url, allow_other_host: true
    end
  
    
    def set_stripe_api_key
      Stripe.api_key = '[API_KEY]'
  end

  
    private
  
    def set_local_moderator
      # Ensure the user is a local moderator
      @user = current_user
      puts "DEBUG: USER CUSTOMER ID: #{current_user.stripe_customer_id}"
      
      redirect_to(root_url) unless @user.local_moderator?
    end
  
    def current_tests
      current_month = Time.now.beginning_of_month..Time.now.end_of_month
      fetch_tests(current_month)
    end
  
    def previous_tests
      previous_month = 1.month.ago.beginning_of_month..1.month.ago.end_of_month
      fetch_tests(previous_month)
    end
  
    def fetch_tests(range)
      {
        rddt_tests: RddtTest.where(created_at: range, tenant_id: @user.tenant_id),
        dnw_tests: DnwTest.where(created_at: range, tenant_id: @user.tenant_id),
        dwt_tests: DwtTest.where(created_at: range, tenant_id: @user.tenant_id)
      }
    
    end
  
  end

  
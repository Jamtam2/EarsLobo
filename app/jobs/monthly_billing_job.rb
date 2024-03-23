# app/jobs/monthly_billing_job.rb

class MonthlyBillingJob < ApplicationJob
    queue_as :default
  
    def perform(*args)
      User.find_each do |user|
        next unless user.stripe_customer_id && user.usage_this_month.positive? && user.local_moderator?
  
        invoice = Stripe::Invoice.create({
          customer: user.stripe_customer_id,
          auto_advance: true, # Automatically finalize the invoice
        })
  
        Stripe::InvoiceItem.create({
          customer: user.stripe_customer_id,
          amount: calculate_monthly_cost(user), # in cents
          currency: 'usd',
          description: 'Monthly tests usage',
          invoice: invoice.id
        })
  
        Stripe::Invoice.finalize_invoice(invoice.id)
      end
    end
  
    private
  
    def calculate_monthly_cost(user)
        # Logic to calculate the user's total cost for the month
        current_month_tests = current_tests(user)
        total_cost = calculate_total_cost(current_month_tests)

  end
  

#   ---------------------------
    def current_tests(user)
        current_month = Time.now.beginning_of_month..Time.now.end_of_month
        fetch_tests(current_month,user)
    end
 
    def fetch_tests(range,user)
        {
        rddt_tests: RddtTest.where(created_at: range, tenant_id: user.tenant_id),
        dnw_tests: DnwTest.where(created_at: range, tenant_id: user.tenant_id),
        dwt_tests: DwtTest.where(created_at: range, tenant_id: user.tenant_id)
        }
    
    end

    def calculate_total_cost(tests)
        total_cost = 0
        tests.values.flatten.each do |test|
            total_cost += test.price
        end
        total_cost
        end
end


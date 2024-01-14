# == Schema Information
#
# Table name: rddt_tests
#
#  id                       :bigint           not null, primary key
#  advantage_percentile     :string
#  client_name              :string
#  ear_advantage            :string
#  ear_advantage_score      :float
#  ear_advantage_score1     :float
#  ear_advantage_score3     :float
#  encrypted_client_name    :string
#  encrypted_client_name_iv :string
#  interpretation           :string
#  label                    :string
#  left_percentile          :string
#  left_score1              :float
#  left_score2              :float
#  left_score3              :float
#  notes                    :text
#  price                    :decimal(10, 2)
#  right_percentile         :string
#  right_score1             :float
#  right_score2             :float
#  right_score3             :float
#  test_type                :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  client_id                :bigint           not null
#  tenant_id                :bigint
#  user_id                  :bigint           not null
#
# Indexes
#
#  index_rddt_tests_on_client_id  (client_id)
#  index_rddt_tests_on_tenant_id  (tenant_id)
#  index_rddt_tests_on_user_id    (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (client_id => clients.id)
#  fk_rails_...  (tenant_id => tenants.id)
#  fk_rails_...  (user_id => users.id)
#
class RddtTest < ApplicationRecord
    acts_as_tenant(:tenant)
  
    belongs_to :client
    belongs_to :user
    before_save :set_default_price

    attr_encrypted :client_name, key: ENV['ENCRYPTION_KEY']

    def set_default_price
        self.price ||= 2.00 # set default price if not present
      end
    
      def apply_discount(discount_code)
        if valid_discount_code?(discount_code)
          self.price = discounted_price
        end
      end
    
      private
    
      def valid_discount_code?(code)
        # Define how to validate a discount code
        # This is just a placeholder
        code == "SPECIALDISCOUNT"
      end
    
      def discounted_price
        # This is just a placeholder
        0.00
      end
    end

# == Schema Information
#
# Table name: payments
#
#  id                    :bigint           not null, primary key
#  amount                :decimal(10, 2)
#  currency              :string
#  description           :text
#  status                :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  stripe_transaction_id :string
#  tenant_id             :bigint
#  user_id               :bigint           not null
#
# Indexes
#
#  index_payments_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require "test_helper"

class PaymentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

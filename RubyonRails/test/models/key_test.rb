# == Schema Information
#
# Table name: keys
#
#  id              :bigint           not null, primary key
#  activation_code :string
#  expiration      :datetime
#  license_type    :integer
#  used            :boolean
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  customer_id     :integer
#  license_id      :integer
#  product_id      :integer
#  subscription_id :integer
#
require "test_helper"

class KeyTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

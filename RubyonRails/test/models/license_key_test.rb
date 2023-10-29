# == Schema Information
#
# Table name: license_keys
#
#  id              :bigint           not null, primary key
#  activation_code :string
#  expiry_date     :datetime
#  is_activated    :boolean
#  issued_date     :datetime
#  license_type    :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  customer_id     :integer
#  product_id      :integer
#  subscription_id :integer
#
require "test_helper"

class LicenseKeyTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

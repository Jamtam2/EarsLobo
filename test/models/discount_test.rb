# == Schema Information
#
# Table name: discounts
#
#  id                  :bigint           not null, primary key
#  code                :string
#  expiration_date     :date
#  percentage_off      :integer
#  redemption_quantity :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
require "test_helper"

class DiscountTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

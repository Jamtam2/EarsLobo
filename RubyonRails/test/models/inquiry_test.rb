# == Schema Information
#
# Table name: inquiries
#
#  id         :bigint           not null, primary key
#  company    :string
#  email      :string
#  purpose    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "test_helper"

class InquiryTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

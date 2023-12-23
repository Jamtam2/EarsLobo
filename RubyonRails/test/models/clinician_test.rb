# == Schema Information
#
# Table name: clinicians
#
#  id         :bigint           not null, primary key
#  email      :string
#  fname      :string
#  lname      :string
#  phone      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  tenant_id  :bigint
#
# Indexes
#
#  index_clinicians_on_tenant_id  (tenant_id)
#
require "test_helper"

class ClinicianTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

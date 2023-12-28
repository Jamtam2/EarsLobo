# == Schema Information
#
# Table name: hashed_data
#
#  hashable_type        :string           not null
#  hashed_address       :string
#  hashed_age           :string
#  hashed_city          :string
#  hashed_country       :string
#  hashed_date_of_birth :string
#  hashed_email         :string
#  hashed_first_name    :string
#  hashed_gender        :string
#  hashed_last_name     :string
#  hashed_phone1        :string
#  hashed_phone2        :string
#  hashed_race          :string
#  hashed_state         :string
#  hashed_zip           :string
#  source_model         :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  hashable_id          :bigint           not null
#  hashed_tenant_id     :string
#  record_id            :bigint           not null, primary key
#
# Indexes
#
#  index_hashed_data_on_hashable  (hashable_type,hashable_id)
#
require "test_helper"

class HashedDatumTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

# == Schema Information
#
# Table name: locations
#
#  id         :bigint           not null, primary key
#  address    :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  key_id     :bigint           not null
#
# Indexes
#
#  index_locations_on_key_id  (key_id)
#
# Foreign Keys
#
#  fk_rails_...  (key_id => keys.id)
#
require "test_helper"

class LocationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

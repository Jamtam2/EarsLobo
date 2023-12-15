# == Schema Information
#
# Table name: user_mfa_sessions
#
#  id         :bigint           not null, primary key
#  activated  :boolean
#  secret_key :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint
#
# Indexes
#
#  index_user_mfa_sessions_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require "test_helper"

class UserMfaSessionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

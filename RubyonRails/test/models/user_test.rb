# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  fname                  :string
#  google_secret          :string
#  lname                  :string
#  mfa_secret             :integer
#  moderator_code         :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  role                   :integer
#  verification_key       :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  tenant_id              :bigint
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_moderator_code        (moderator_code)
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_tenant_id             (tenant_id)
#
# Foreign Keys
#
#  fk_rails_...  (tenant_id => tenants.id)
#
require "test_helper"

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

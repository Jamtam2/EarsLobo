# == Schema Information
#
#  id             :bigint           not null, primary key
#  activated      :boolean
#  email_2fa_code :string
#  email_verified :boolean
#  secret_key     :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  user_id        :bigint
#
# Indexes
#
#  index_user_mfa_sessions_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class UserMfaSession < ApplicationRecord
end

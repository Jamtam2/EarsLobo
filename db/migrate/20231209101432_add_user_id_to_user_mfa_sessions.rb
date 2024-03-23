class AddUserIdToUserMfaSessions < ActiveRecord::Migration[6.1]
  def change
    add_reference :user_mfa_sessions, :user, foreign_key: true

  end
end

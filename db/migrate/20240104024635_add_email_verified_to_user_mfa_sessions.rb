class AddEmailVerifiedToUserMfaSessions < ActiveRecord::Migration[6.1]
  def change
    add_column :user_mfa_sessions, :email_verified, :boolean
  end
end

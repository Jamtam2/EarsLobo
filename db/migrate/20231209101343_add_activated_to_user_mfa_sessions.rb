class AddActivatedToUserMfaSessions < ActiveRecord::Migration[6.1]
  def change
    add_column :user_mfa_sessions, :activated, :boolean
  end
end

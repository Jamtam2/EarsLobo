class AddSecretKeyToUserMfaSessions < ActiveRecord::Migration[6.1]
  def change
    add_column :user_mfa_sessions, :secret_key, :string
    
  end
end

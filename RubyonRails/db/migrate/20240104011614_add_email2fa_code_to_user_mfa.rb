class AddEmail2faCodeToUserMfa < ActiveRecord::Migration[6.1]
  def change
    add_column :user_mfa_sessions, :email_2fa_code, :string
  end
end

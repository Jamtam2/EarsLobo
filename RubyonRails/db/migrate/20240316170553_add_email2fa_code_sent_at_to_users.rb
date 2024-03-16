class AddEmail2faCodeSentAtToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :email_2fa_code_sent_at, :datetime
  end
end

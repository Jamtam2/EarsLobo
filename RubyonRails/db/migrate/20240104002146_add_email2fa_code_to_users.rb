class AddEmail2faCodeToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :email_2fa_code, :string
  end
end

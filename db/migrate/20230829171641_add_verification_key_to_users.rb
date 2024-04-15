class AddVerificationKeyToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :verification_key, :string
  end
end

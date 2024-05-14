class AddIvDobStringToClients < ActiveRecord::Migration[6.1]
  def change
    add_column :clients, :encrypted_dob_string_iv, :string
  end
end

class ModifyColumnsForEncryptionInClients < ActiveRecord::Migration[6.1]
  def change

    add_column :clients, :encrypted_email_iv, :string
    add_column :clients, :encrypted_address1_iv, :string
    add_column :clients, :encrypted_date_of_birth_iv, :string
    add_column :clients, :encrypted_first_name_iv, :string
    add_column :clients, :encrypted_last_name_iv, :string
    add_column :clients, :encrypted_phone1_iv, :string
    add_column :clients, :encrypted_phone2_iv, :string
    add_column :clients, :encrypted_gender_iv, :string
    add_column :clients, :encrypted_race_iv, :string
    add_column :clients, :encrypted_zip_iv, :string

  end
end

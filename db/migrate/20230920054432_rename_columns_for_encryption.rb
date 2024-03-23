class RenameColumnsForEncryption < ActiveRecord::Migration[6.1]
  def change
    rename_column :clients, :email, :encrypted_email
    rename_column :clients, :address1, :encrypted_address1
    rename_column :clients, :date_of_birth, :encrypted_date_of_birth
    rename_column :clients, :first_name, :encrypted_first_name
    rename_column :clients, :last_name, :encrypted_last_name
    rename_column :clients, :phone1, :encrypted_phone1
    rename_column :clients, :phone2, :encrypted_phone2
    rename_column :clients, :gender, :encrypted_gender
    rename_column :clients, :race, :encrypted_race
    rename_column :clients, :zip, :encrypted_zip
  end
end

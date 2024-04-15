class AddEncryptedFieldsToEmergencyContact < ActiveRecord::Migration[6.1]
  def change
    rename_column :emergency_contacts, :address, :encrypted_address
    rename_column :emergency_contacts, :city, :encrypted_city
    rename_column :emergency_contacts, :email, :encrypted_email
    rename_column :emergency_contacts, :first_name, :encrypted_first_name
    rename_column :emergency_contacts, :last_name, :encrypted_last_name
    rename_column :emergency_contacts, :phone_number, :encrypted_phone_number
    rename_column :emergency_contacts, :state, :encrypted_state

    add_column :emergency_contacts, :encrypted_address_iv, :string
    add_column :emergency_contacts, :encrypted_city_iv, :string


    add_column :emergency_contacts, :encrypted_email_iv, :string
    add_column :emergency_contacts, :encrypted_first_name_iv, :string
    add_column :emergency_contacts, :encrypted_last_name_iv, :string
    add_column :emergency_contacts, :encrypted_phone_number_iv, :string
    add_column :emergency_contacts, :encrypted_state_iv, :string


  end
end

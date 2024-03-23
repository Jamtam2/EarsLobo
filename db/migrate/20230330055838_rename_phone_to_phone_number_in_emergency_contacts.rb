class RenamePhoneToPhoneNumberInEmergencyContacts < ActiveRecord::Migration[6.1]
  def change
    rename_column :emergency_contacts, :phone, :phone_number
  end
end

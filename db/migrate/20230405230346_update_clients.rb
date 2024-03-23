class UpdateClients < ActiveRecord::Migration[6.1]
  def change
    remove_column :clients, :emergency_contact_address1
    remove_column :clients, :emergency_contact_city
    remove_column :clients, :emergency_contact_first_name
    remove_column :clients, :emergency_contact_last_name
    remove_column :clients, :emergency_contact_phone1
    remove_column :clients, :emergency_contact_phone2


  end
end

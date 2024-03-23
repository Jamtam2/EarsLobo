class CreateClients < ActiveRecord::Migration[6.1]
  def change
    create_table :clients do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.date :date_of_birth
      t.string :mgmt_ref
      t.string :gender
      t.string :address1
      t.string :country
      t.string :state
      t.string :city
      t.string :zip
      t.string :phone1
      t.string :phone2
      t.string :emergency_contact_first_name
      t.string :emergency_contact_last_name
      t.string :emergency_contact_phone1
      t.string :emergency_contact_phone2
      t.string :emergency_contact_address1
      t.string :emergency_contact_city

      t.timestamps
    end
  end
end

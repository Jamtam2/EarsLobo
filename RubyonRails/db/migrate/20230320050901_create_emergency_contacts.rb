class CreateEmergencyContacts < ActiveRecord::Migration[6.1]
  def change
    create_table :emergency_contacts do |t|
      t.string :first_name
      t.string :last_name
      t.string :phone_number
      t.string :address
      t.string :email
      t.string :city
      t.string :state
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end

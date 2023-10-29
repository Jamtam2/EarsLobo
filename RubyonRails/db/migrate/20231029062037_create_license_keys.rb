class CreateLicenseKeys < ActiveRecord::Migration[6.1]
  def change
    create_table :license_keys do |t|
      t.integer :product_id
      t.integer :customer_id
      t.integer :subscription_id
      t.integer :license_type
      t.string :activation_code
      t.datetime :issued_date
      t.datetime :expiry_date
      t.boolean :is_activated, default: false

      t.timestamps
    end
  end
end

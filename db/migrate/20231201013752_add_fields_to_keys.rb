class AddFieldsToKeys < ActiveRecord::Migration[6.1]
  def change
    add_column :keys, :license_id, :integer
    add_column :keys, :activation_code, :string
    add_column :keys, :license_type, :integer
    add_column :keys, :expiration, :datetime
    add_column :keys, :product_id, :integer
    add_column :keys, :customer_id, :integer
    add_column :keys, :subscription_id, :integer
  end
end

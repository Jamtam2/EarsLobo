class AddHashedAttributesToHashedData < ActiveRecord::Migration[6.1]
  def change
    add_column :hashed_data, :hashed_first_name, :string
    add_column :hashed_data, :hashed_last_name, :string
    add_column :hashed_data, :hashed_email, :string
    add_column :hashed_data, :hashed_gender, :string
    add_column :hashed_data, :hashed_age, :string
    add_column :hashed_data, :hashed_date_of_birth, :string
    add_column :hashed_data, :hashed_phone, :string
    add_column :hashed_data, :hashed_address, :string
    add_column :hashed_data, :hashed_country, :string
    add_column :hashed_data, :hashed_state, :string
    add_column :hashed_data, :hashed_city, :string
    add_column :hashed_data, :hashed_tenant_id, :string
    add_column :hashed_data, :hashed_zip, :string
    add_column :hashed_data, :hashed_race, :string

    remove_column :hashed_data, :hashed_value, :string
    remove_column :hashed_data, :source_attribute, :string
  end
end

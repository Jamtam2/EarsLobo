class AddAttributesToHashedData < ActiveRecord::Migration[6.1]
  def change
    add_column :hashed_data, :hashed_phone1, :string
    add_column :hashed_data, :hashed_phone2, :string

    remove_column :hashed_data, :hashed_phone, :string
  end
end

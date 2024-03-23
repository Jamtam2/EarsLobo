class ChangePrimaryKeyForHashedData < ActiveRecord::Migration[6.1]
  def change
    # remove the old primary key
    remove_column :hashed_data, :id # or whatever the current primary key is

    # add the new primary key
    add_column :hashed_data, :record_id, :primary_key
  end
end

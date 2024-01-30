class AddLocationToKeys < ActiveRecord::Migration[6.1]
  def change
    add_column :keys, :location, :string
    add_column :keys, :location_id, :integer
  end
end

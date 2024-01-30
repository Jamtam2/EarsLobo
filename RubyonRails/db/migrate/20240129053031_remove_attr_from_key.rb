class RemoveAttrFromKey < ActiveRecord::Migration[6.1]
  def change
    remove_column :keys, :location, :string
    remove_column :keys, :location_id, :integer
  end
end

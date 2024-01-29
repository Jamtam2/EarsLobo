class RemoveAttrFromLocation < ActiveRecord::Migration[6.1]
  def change
    remove_column :locations, :location_id, :integer
  end
end

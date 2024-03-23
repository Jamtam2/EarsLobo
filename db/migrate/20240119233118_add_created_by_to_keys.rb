class AddCreatedByToKeys < ActiveRecord::Migration[6.1]
  def change
    add_column :keys, :created_by_id, :integer
  end
end

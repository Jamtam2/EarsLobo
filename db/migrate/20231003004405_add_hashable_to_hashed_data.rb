class AddHashableToHashedData < ActiveRecord::Migration[6.1]
  def change
    add_reference :hashed_data, :hashable, polymorphic: true, null: false
  end
end

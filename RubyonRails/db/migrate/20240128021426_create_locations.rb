class CreateLocations < ActiveRecord::Migration[6.1]
  def change
    create_table :locations do |t|
      t.string :name
      t.string :address
      t.integer :location_id
      t.references :key, null: false, foreign_key: true

      t.timestamps
    end
  end
end

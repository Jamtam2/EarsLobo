class CreateHashedData < ActiveRecord::Migration[6.1]
  def change
    create_table :hashed_data do |t|
      t.string :source_model
      t.string :source_attribute
      t.string :hashed_value

      t.timestamps
    end
  end
end

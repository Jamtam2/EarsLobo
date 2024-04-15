class CreateKeys < ActiveRecord::Migration[6.1]
  def change
    create_table :keys do |t|
      t.string :code
      t.boolean :used

      t.timestamps
    end
    add_index :keys, :code, unique: true
  end
end

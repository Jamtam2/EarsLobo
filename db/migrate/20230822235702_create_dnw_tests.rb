class CreateDnwTests < ActiveRecord::Migration[6.1]
  def change
    create_table :dnw_tests do |t|
      t.string :label
      t.string :test_type
      t.string :client_name
      t.text :notes
      t.string :ear_advantage
      t.float :left_score
      t.float :right_score
      t.float :ear_advantage_score
      t.string :interpretation

      t.references :client, null: false, foreign_key: true

      t.timestamps
    end
  end
end

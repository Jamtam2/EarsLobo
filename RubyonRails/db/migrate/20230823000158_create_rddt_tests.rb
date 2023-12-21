class CreateRddtTests < ActiveRecord::Migration[6.1]
  def change
    create_table :rddt_tests do |t|
      t.string :label
      t.string :test_type
      t.string :client_name
      t.text :notes
      t.string :ear_advantage
      t.float :left_score1
      t.float :left_score2
      t.float :left_score3
      t.float :right_score1
      t.float :right_score2
      t.float :right_score3
      t.float :ear_advantage_score
      t.float :ear_advantage_score1
      t.float :ear_advantage_score3
      t.string :interpretation
      t.string :left_percentile
      t.string :right_percentile
      t.string :advantage_percentile

      t.references :client, null: false, foreign_key: true

      t.timestamps
    end
  end
end

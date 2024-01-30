class CreateJoinTableLocationUser < ActiveRecord::Migration[6.1]
  def change
    create_join_table :locations, :users do |t|
      t.index :location_id
      t.index :user_id
    end
  end
end

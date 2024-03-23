class AddModeratorCodeToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :moderator_code, :string
    add_index :users, :moderator_code
  end
end

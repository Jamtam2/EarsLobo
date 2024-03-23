class AddEmailToKeys < ActiveRecord::Migration[6.1]
  def change
    add_column :keys, :email, :string
  end
end

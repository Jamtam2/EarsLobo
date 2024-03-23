class RemoveCodeFromKeys < ActiveRecord::Migration[6.1]
  def change
    remove_column :keys, :code, :string

  end
end

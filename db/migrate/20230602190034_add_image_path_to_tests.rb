class AddImagePathToTests < ActiveRecord::Migration[6.1]
  def change
    add_column :tests, :image_path, :string
  end
end

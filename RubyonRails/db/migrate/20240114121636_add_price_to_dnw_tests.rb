class AddPriceToDnwTests < ActiveRecord::Migration[6.1]
  def change
    add_column :dnw_tests, :price, :decimal, precision: 10, scale: 2
  end
end

class AddPriceToDwtTests < ActiveRecord::Migration[6.1]
  def change
    add_column :dwt_tests, :price, :decimal, precision: 10, scale: 2
  end
end

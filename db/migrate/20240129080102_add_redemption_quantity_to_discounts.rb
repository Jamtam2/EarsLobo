class AddRedemptionQuantityToDiscounts < ActiveRecord::Migration[6.1]
  def change
    add_column :discounts, :redemption_quantity, :integer
  end
end

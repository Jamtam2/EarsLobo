class AddExpirationDateToDiscounts < ActiveRecord::Migration[6.1]
  def change
    add_column :discounts, :expiration_date, :date
  end
end

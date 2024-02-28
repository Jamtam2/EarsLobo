class ChangeCustomerIdToStringInKeys < ActiveRecord::Migration[6.1]
  def change
    change_column :keys, :customer_id, :string

  end
end

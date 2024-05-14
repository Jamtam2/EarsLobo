class AddOutstandingBalanceToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :outstanding_balance, :boolean
  end
end

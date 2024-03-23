class CreatePayments < ActiveRecord::Migration[6.1]
  def change
    create_table :payments do |t|
      t.decimal :amount, precision: 10, scale: 2
      t.string :stripe_transaction_id
      t.references :user, null: false, foreign_key: true
      t.bigint :tenant_id, null: false
      t.string :currency
      t.string :status
      t.text :description

      t.timestamps
    end
    add_foreign_key :payments, :tenants, columns: :tenant_id
  end
end

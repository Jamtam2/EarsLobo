class AddTenantToDwtTests < ActiveRecord::Migration[6.1]
  def change
    add_reference :dwt_tests, :tenant, foreign_key: true
  end
end

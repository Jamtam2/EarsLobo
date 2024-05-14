class AddTenantToDnwTests < ActiveRecord::Migration[6.1]
  def change
    add_reference :dnw_tests, :tenant, foreign_key: true
  end
end

class AddTenantToRddtTests < ActiveRecord::Migration[6.1]
  def change
    add_reference :rddt_tests, :tenant, foreign_key: true
  end
end

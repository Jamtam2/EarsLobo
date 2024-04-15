class AddTenantToMultipleModels < ActiveRecord::Migration[6.1]
  def change
    add_reference :users, :tenant, foreign_key: true
    add_reference :tests, :tenant, foreign_key: true
    add_reference :clients, :tenant, foreign_key: true
    add_reference :clinicians, :tenant, foreign_key: true
    add_reference :emergency_contacts, :tenant, foreign_key: true

  end
end

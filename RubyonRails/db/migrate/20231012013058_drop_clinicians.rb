class DropClinicians < ActiveRecord::Migration[6.1]
  def up
    drop_table :clinicians
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end

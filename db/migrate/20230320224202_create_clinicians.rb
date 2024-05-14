class CreateClinicians < ActiveRecord::Migration[6.1]
  def change
    create_table :clinicians do |t|
      t.string :fname
      t.string :lname
      t.string :email
      t.string :phone

      t.timestamps
    end
  end
end

class CreateInquiries < ActiveRecord::Migration[6.1]
  def change
    create_table :inquiries do |t|
      t.string :email
      t.string :company
      t.text :purpose

      t.timestamps
    end
  end
end

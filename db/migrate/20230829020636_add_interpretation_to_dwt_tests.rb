class AddInterpretationToDwtTests < ActiveRecord::Migration[6.1]
  def change
    add_column :dwt_tests, :interpretation, :string
  end
end

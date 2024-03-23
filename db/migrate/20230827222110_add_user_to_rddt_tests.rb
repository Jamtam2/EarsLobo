class AddUserToRddtTests < ActiveRecord::Migration[6.1]
  def change
    add_reference :rddt_tests, :user, null: false, foreign_key: true
  end
end

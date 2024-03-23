class AddUserToDnwTests < ActiveRecord::Migration[6.1]
  def change
    add_reference :dnw_tests, :user, null: false, foreign_key: true
  end
end

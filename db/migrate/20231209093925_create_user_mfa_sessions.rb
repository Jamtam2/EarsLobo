class CreateUserMfaSessions < ActiveRecord::Migration[6.1]
  def change
    create_table :user_mfa_sessions do |t|

      t.timestamps
    end
  end
end

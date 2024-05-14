class ChangePhone1DataTypeToString < ActiveRecord::Migration[6.1]
    def change
      change_column :clients, :phone1, :string
    end
  end
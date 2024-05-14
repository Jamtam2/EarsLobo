class AddRaceToClients < ActiveRecord::Migration[6.1]
  def change
    add_column :clients, :race, :string
  end
end

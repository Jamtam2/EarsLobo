class AddEncryptedFieldsToModels < ActiveRecord::Migration[6.0]
  def change
    # Add encrypted fields to DnwTest
    add_column :dnw_tests, :encrypted_client_name, :string
    add_column :dnw_tests, :encrypted_client_name_iv, :string

    # Add encrypted fields to DwtTest
    add_column :dwt_tests, :encrypted_client_name, :string
    add_column :dwt_tests, :encrypted_client_name_iv, :string

    # Add encrypted fields to RddtTest
    add_column :rddt_tests, :encrypted_client_name, :string
    add_column :rddt_tests, :encrypted_client_name_iv, :string
  end
end

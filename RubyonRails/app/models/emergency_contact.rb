# == Schema Information
#
# Table name: emergency_contacts
#
#  id                        :bigint           not null, primary key
#  encrypted_address         :string
#  encrypted_address_iv      :string
#  encrypted_city            :string
#  encrypted_city_iv         :string
#  encrypted_email           :string
#  encrypted_email_iv        :string
#  encrypted_first_name      :string
#  encrypted_first_name_iv   :string
#  encrypted_last_name       :string
#  encrypted_last_name_iv    :string
#  encrypted_phone_number    :string
#  encrypted_phone_number_iv :string
#  encrypted_state           :string
#  encrypted_state_iv        :string
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  client_id                 :bigint           not null
#  tenant_id                 :bigint
#
# Indexes
#
#  index_emergency_contacts_on_client_id  (client_id)
#  index_emergency_contacts_on_tenant_id  (tenant_id)
#
# Foreign Keys
#
#  fk_rails_...  (client_id => clients.id)
#  fk_rails_...  (tenant_id => tenants.id)
#
class EmergencyContact < ApplicationRecord
  acts_as_tenant(:tenant)

  belongs_to :client
  attr_encrypted :email, :address, :city, :first_name, :last_name, :phone_number, :state, key: ENV['ENCRYPTION_KEY']
  
  validates :first_name, :last_name, :phone_number, :email, presence: true

end

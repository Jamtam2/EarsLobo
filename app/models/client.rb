# == Schema Information
#
# Table name: clients
#
#  id                         :bigint           not null, primary key
#  city                       :string
#  country                    :string
#  encrypted_address1         :string
#  encrypted_address1_iv      :string
#  encrypted_date_of_birth    :date
#  encrypted_date_of_birth_iv :string
#  encrypted_dob_string       :string
#  encrypted_dob_string_iv    :string
#  encrypted_email            :string
#  encrypted_email_iv         :string
#  encrypted_first_name       :string
#  encrypted_first_name_iv    :string
#  encrypted_gender           :string
#  encrypted_gender_iv        :string
#  encrypted_last_name        :string
#  encrypted_last_name_iv     :string
#  encrypted_phone1           :string
#  encrypted_phone1_iv        :string
#  encrypted_phone2           :string
#  encrypted_phone2_iv        :string
#  encrypted_race             :string
#  encrypted_race_iv          :string
#  encrypted_zip              :string
#  encrypted_zip_iv           :string
#  mgmt_ref                   :string
#  state                      :string
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  tenant_id                  :bigint
#
# Indexes
#
#  index_clients_on_tenant_id  (tenant_id)
#
# Foreign Keys
#
#  fk_rails_...  (tenant_id => tenants.id)
#
class Client < ApplicationRecord
  acts_as_tenant(:tenant)
  
  attr_encrypted :email, :address1, :date_of_birth, :first_name, :last_name, :phone1, :phone2, :gender, :race, :zip, key: ENV['ENCRYPTION_KEY']
  attr_encrypted :dob_string, key: ENV['ENCRYPTION_KEY']

  
    has_many :emergency_contacts,dependent: :destroy
    has_many :dwt_tests,dependent: :destroy
    has_many :dnw_tests,dependent: :destroy
    has_many :rddt_tests,dependent: :destroy
    has_many :hashed_data, as: :hashable, dependent: :destroy

    after_save :store_hashed_data
  # Associations with emergency contacts and tests, with dependent destroy option


  # Allow nested attributes for emergency contacts
  accepts_nested_attributes_for :emergency_contacts


  #Method hashes the data from the Client model into the hashed_data model so it can be filter with Ransack
  private def store_hashed_data
    # Create a new HashedDatum object
    hashed_datum = HashedDatum.new(
      source_model: "Client",
      created_at: created_at,
      updated_at: updated_at
    # You might need to set hashable_id and hashable_type here, depending on your setup
      )

    # Map each client attribute to its respective hashed_data attribute
    attribute_map = {
      'email' => 'hashed_email',
      'address1' => 'hashed_address',
      'dob_string' => 'hashed_date_of_birth',
      'first_name' => 'hashed_first_name',
      'last_name' => 'hashed_last_name',
      'phone1' => 'hashed_phone1',
      'phone2' => 'hashed_phone2',
      'gender' => 'hashed_gender',
      'race' => 'hashed_race',
      'zip' => 'hashed_zip',
      'age_in_years' => 'hashed_age',
      'city' => 'hashed_city',
      'state' => 'hashed_state',
      'country' => 'hashed_country',
      'tenant_id' => 'hashed_tenant_id'
    }

    # Loop over every client attribute, hash the value, and store it in the correct hashed_data attribute
    attribute_map.each do |client_attr, hashed_attr|
      value = self.send(client_attr)

      # Convert value to string if its not already
      stringified_value = value.is_a?(String) ? value : value.to_s

      # Hash the string
      hashed_value = Digest::SHA256.hexdigest(stringified_value)
      #   hashed_value = stringified_value

      # Store the hashed value in the hashed_datum
      hashed_datum.send("#{hashed_attr}=", hashed_value)
    end

    # Save the new hashed_datum record
    self.hashed_data << hashed_datum
    hashed_datum.save!
  end


  # def self.decrypt_client_names_for_tenant(tenant_id)
  #   clients = where(tenant_id: tenant_id)
  #
  #   clients.map do |client|
  #     {
  #       client_id: client.id,
  #       decrypted_client_name: client.first_name  # This will automatically decrypt the name
  #     }
  #   end
  # end


  def date_of_birth=(date)
      self.dob_string = date.to_s
    end
    # The setter for the raw_date_of_birth, used internally
   

    def date_of_birth
      return if dob_string.nil?
      Date.parse(dob_string)
    end
    
  

    def full_name
      "#{first_name}#{last_name}"
    end
#age in years method that calculates a clients age based on DOB then passes it to the script test page
    def age_in_years
      now = Time.now.utc.to_date
      dob = date_of_birth
      
      age = now.year - dob.year
      age -= 1 if now < dob + age.years # for days before birthday
      age
    end


    def anonymized
      self.attributes.except('address1', 'email', 'phone1', 'phone2')
        .merge({
          'address1' => Digest::SHA256.hexdigest(self.address1),
          'email' => Digest::SHA256.hexdigest(self.email),
          'phone1' => Digest::SHA256.hexdigest(self.phone1),
          'phone2' => Digest::SHA256.hexdigest(self.phone2)
        })
    end
  # Validations for various client attributes
  validates :first_name, :last_name, :email, :address1, :country, :state, :city, :zip, :phone1, :date_of_birth, presence: true

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone1, numericality: { only_integer: true }

  # Allow these attributes to be searched through Ransack
  def self.ransackable_attributes(auth_object = nil)
    %w(address1 city country date_of_birth email first_name gender last_name mgmt_ref phone1 phone2 race state zip created_at updated_at age_in_years age ) + _ransackers.keys
  end
  
  # Allow these associations to be searched through Ransack. Can use attributes from different models.
  def self.ransackable_associations(auth_object = nil)
    %w(dwt_tests hashed_data) # Allows the use of this model in the Client model now.
  end

  # Controls the functionality behind thw advanced searching for this attribute of id
  ransacker :id do
    Arel.sql('id')
  end

  # Method Allows for the Age_in_years method to be used in sorting for age
  def self.sort_by_age_in_years(direction = 'asc')
    direction = %w[asc desc].include?(direction) ? direction : 'asc'
    order(Arel.sql("EXTRACT(YEAR FROM age(date_of_birth)) #{direction}"))
  end

  # Allows attribute to be used as a search parameter
  ransacker :age_in_years do
    Arel.sql("EXTRACT(YEAR FROM age(date_of_birth))")
  end
  

end
  



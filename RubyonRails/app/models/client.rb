# == Schema Information
#
# Table name: clients
#
#  id            :bigint           not null, primary key
#  address1      :string
#  city          :string
#  country       :string
#  date_of_birth :date
#  email         :string
#  first_name    :string
#  gender        :string
#  last_name     :string
#  mgmt_ref      :string
#  phone1        :string
#  phone2        :string
#  race          :string
#  state         :string
#  zip           :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  tenant_id     :bigint
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


    has_many :emergency_contacts,dependent: :destroy
    has_many :dwt_tests,dependent: :destroy
    has_many :dnw_tests,dependent: :destroy
    has_many :rddt_tests,dependent: :destroy
  # Associations with emergency contacts and tests, with dependent destroy option


  # Allow nested attributes for emergency contacts
  accepts_nested_attributes_for :emergency_contacts

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
  validates :first_name, :last_name, :email, :date_of_birth, :address1, :country, :state, :city, :zip, :phone1, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone1, numericality: { only_integer: true }

  # Allow these attributes to be searched through Ransack
  def self.ransackable_attributes(auth_object = nil)
    %w(address1 city country date_of_birth email first_name gender last_name mgmt_ref phone1 phone2 race state zip created_at updated_at age_in_years age ) + _ransackers.keys
  end

  # Allow these associations to be searched through Ransack. Can use attributes from different models.
  def self.ransackable_associations(auth_object = nil)
    ["dwt_tests"] # Allows the use of this model in the Client model now.
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
  



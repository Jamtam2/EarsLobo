# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  fname                  :string
#  lname                  :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  role                   :integer
#  verification_key       :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  tenant_id              :bigint
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_tenant_id             (tenant_id)
#
# Foreign Keys
#
#  fk_rails_...  (tenant_id => tenants.id)
#
class User < ApplicationRecord
  acts_as_tenant(:tenant)

  belongs_to :tenant
  enum role: { regular_user: 0, local_moderator: 1, global_moderator: 2, owner: 3 }

  attr_accessor :registration_key
  before_validation :validate_registration_key, on: :create

  # Will validate the verification key only for the owner.
  validates :verification_key, presence: true, if: :owner?


  has_many :dwt_tests,dependent: :destroy
  has_many :dnw_tests,dependent: :destroy
  has_many :rddt_tests,dependent: :destroy
  has_many :clients, foreign_key: :tenant_id, primary_key: :tenant_id

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Returns true if the user's role is 'global_moderator'.
  def global_moderator?
    role == 'global_moderator'
  end

  # Returns true if the user's role is 'local_moderator'.
  def local_moderator?
    role == 'local_moderator'
  end

  # Returns true if the user's role is 'owner'.
  def owner?
    role == 'owner'
  end


  # Validates the provided registration key.
  #
  # This method checks for the presence of a license key in the database with the given
  # activation code and that it has not already been activated. If such a key is found,
  # it updates the key's status to mark it as activated.
  #
  # It logs the details of the key check and update operations. If no valid key is found,
  # or if it has already been activated, an error is added to the `registration_key` field,
  # and it logs an error message.
  #
  # This method is meant to be called within an instance context where `registration_key`
  # is expected to be an accessible attribute.
  #
  # No parameters.
  #
  # Returns:
  # - nil if a valid, non-activated key is found and successfully updated.
  # - false if no valid key is found, and the `registration_key` attribute has an error added.
  private
  def validate_registration_key
    key = LicenseKey.find_by(activation_code: registration_key, is_activated: false)
    Rails.logger.debug("DEBUG fn validate_registration_key checker: #{key.inspect}")

    # Verify key status; change key if not in use
    if key.present? && !key.is_activated
      key.update(is_activated: true)
      Rails.logger.debug("DEBUG: Valid registration key found: #{key.inspect}")
      nil
    else
      errors.add(:registration_key, "is invalid.")
      Rails.logger.error("ERROR: Invalid registration key: #{registration_key}")
      false
    end
  end
  
  
  def generate_subdomain
    # You may want to generate a subdomain based on some user's data (for example, email).
    # This is a very basic implementation which takes a part before '@' symbol from the email.
    # Be aware this might not be unique. You will need to add validations or create more sophisticated logic.
    self.email.split('@').first
  end
end


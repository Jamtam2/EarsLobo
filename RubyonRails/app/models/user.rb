# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  email_2fa_code         :string
#  encrypted_password     :string           default(""), not null
#  fname                  :string
#  google_secret          :string
#  lname                  :string
#  mfa_secret             :integer
#  moderator_code         :string
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
#  index_users_on_moderator_code        (moderator_code)
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_tenant_id             (tenant_id)
#
# Foreign Keys
#
#  fk_rails_...  (tenant_id => tenants.id)
#
class User < ApplicationRecord

  # Add a field for the unique moderator code
  attribute :moderator_code, :string

  # Callback to generate a unique code for local moderators
  before_create :generate_unique_code, if: :local_moderator?

  acts_as_tenant(:tenant)
  
  acts_as_google_authenticated google_secret: :google_secret, mfa_secret: :mfa_secret

  belongs_to :tenant
  enum role: { regular_user: 0, local_moderator: 1, global_moderator: 2, owner: 3 }

  scope :local_moderators, -> { where(role: roles[:local_moderator]) }

  attr_accessor :registration_key
  # before_validation :validate_registration_key, on: :create
  before_validation :validate_registration_key, on: :create

  # Will validate the verification key only for the owner.
  validates :verification_key, presence: true, if: :owner?


  has_many :dwt_tests,dependent: :destroy
  has_many :dnw_tests,dependent: :destroy
  has_many :rddt_tests,dependent: :destroy
  has_many :clients, foreign_key: :tenant_id, primary_key: :tenant_id
  has_many :user_mfa_sessions, dependent: :destroy
  has_many :payments, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # function checks to see if the role of the user is a global moderator
  def global_moderator?
    role == 'global_moderator'
  end

  # function checks to see if the role of the user is a local moderator
  def local_moderator?
    role == 'local_moderator'
  end

  # function checks to see if the role of the user is the owner
  def owner?
    role == 'owner'
  end

  def regular_user?
    role == 'regular_user'
  end

  def generate_qr_code
    totp = ROTP::TOTP.new(self.user_mfa_sessions.first.secret_key)
    label = "#{self.email}"
    totp.provisioning_uri(label)
  end
  
  def google_authentic?(provided_code)
    totp = ROTP::TOTP.new(google_secret)
    # Allow 30 seconds drift behind and ahead
    drift_behind = 30
    drift_ahead = 30
    totp.verify(provided_code, at: Time.now, drift_behind: drift_behind, drift_ahead: drift_ahead)
  end
  
  
  # functions finds the code for the registration key and checks to see if the key has been used or not. 
  # This determines if the key for registration has been used or not.

  private

  # Also move this method back to the User model
  def validate_registration_key
    key = Key.find_by(activation_code: registration_key)

    if key.present? && !key.used
      puts "Valid registration key found: #{key.inspect}"
    else
      errors.add(:registration_key, "is invalid.")
      return false
    end
  end

  private

  # Generate a unique code only for local moderators
  def generate_unique_code
    # Ensure the generated code is unique across all users
    loop do
      self.moderator_code = SecureRandom.hex(10)
      break unless User.exists?(moderator_code: self.moderator_code)
    end
  end

  public

  def license_key
    Key.find_by(email: email)
  end

end

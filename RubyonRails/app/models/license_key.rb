# == Schema Information
#
# Table name: license_keys
#
#  id              :bigint           not null, primary key
#  activation_code :string
#  expiry_date     :datetime
#  is_activated    :boolean
#  issued_date     :datetime
#  license_type    :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  customer_id     :integer
#  product_id      :integer
#  subscription_id :integer
#
class LicenseKey < ApplicationRecord
  # validates :activation_code, presence: true, uniqueness: true
  # validates :license_type, :customer_id, :product_id, presence: true
end

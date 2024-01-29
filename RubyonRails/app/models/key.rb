# == Schema Information
#
# Table name: keys
#
#  id              :bigint           not null, primary key
#  activation_code :string
#  email           :string
#  expiration      :datetime
#  license_type    :integer
#  used            :boolean
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  customer_id     :integer
#  license_id      :integer
#  product_id      :integer
#  subscription_id :integer
#
class Key < ApplicationRecord
    before_create :set_default_used

    has_many :locations
  
    private
  
    def set_default_used
      self.used = false if self.used.nil?
    end

    def self.expired
      where('expiration > ?', Time.current)
    end

    public
    def associated_user_by_email
      User.find_by(email: self.email)
    end
end
  

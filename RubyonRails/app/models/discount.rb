# == Schema Information
#
# Table name: discounts
#
#  id             :bigint           not null, primary key
#  code           :string
#  percentage_off :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class Discount < ApplicationRecord
    validates :code, presence: true, uniqueness: true
    validates :percentage_off, numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 100 }
  
end

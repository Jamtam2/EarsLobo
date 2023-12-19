# == Schema Information
#
# Table name: inquiries
#
#  id         :bigint           not null, primary key
#  company    :string
#  email      :string
#  purpose    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Inquiry < ApplicationRecord
    validates :email, presence: true
    validates :company, presence: true
    validates :purpose, presence: true
  
end

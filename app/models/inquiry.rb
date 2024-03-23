# == Schema Information
#
# Table name: inquiries
#
#  id           :bigint           not null, primary key
#  bug_report   :string
#  company      :string
#  email        :string
#  inquiry_type :string
#  purpose      :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Inquiry < ApplicationRecord
    validates :email, :purpose, presence: true
    validates :company, presence: true, if: -> { inquiry_type == 'dataset_access' }
end

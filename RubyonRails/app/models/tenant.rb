# == Schema Information
#
# Table name: tenants
#
#  id         :bigint           not null, primary key
#  subdomain  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Tenant < ApplicationRecord
    has_many :users
    has_many :dwt_tests,dependent: :destroy
    has_many :dnw_tests,dependent: :destroy
    has_many :rddt_tests,dependent: :destroy
    has_many :clients,dependent: :destroy

end

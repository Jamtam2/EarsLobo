# == Schema Information
#
# Table name: rddt_tests
#
#  id                  :bigint           not null, primary key
#  client_name         :string
#  ear_advantage       :string
#  ear_advantage_score :float
#  label               :string
#  left_score1         :float
#  left_score2         :float
#  left_score3         :float
#  notes               :text
#  right_score1        :float
#  right_score2        :float
#  right_score3        :float
#  test_type           :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  client_id           :bigint           not null
#
# Indexes
#
#  index_rddt_tests_on_client_id  (client_id)
#
# Foreign Keys
#
#  fk_rails_...  (client_id => clients.id)
#
class RddtTest < ApplicationRecord
    acts_as_tenant(:tenant)
  
    belongs_to :client
    belongs_to :user
end
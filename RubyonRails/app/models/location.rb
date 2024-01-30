# == Schema Information
#
# Table name: locations
#
#  id         :bigint           not null, primary key
#  address    :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  key_id     :bigint           not null
#
# Indexes
#
#  index_locations_on_key_id  (key_id)
#
# Foreign Keys
#
#  fk_rails_...  (key_id => keys.id)
#
class Location < ApplicationRecord
  belongs_to :key

  has_and_belongs_to_many :users

  validates :name, presence: true

end

# == Schema Information
#
# Table name: hashed_data
#
#  hashable_type        :string           not null
#  hashed_address       :string
#  hashed_age           :string
#  hashed_city          :string
#  hashed_country       :string
#  hashed_date_of_birth :string
#  hashed_email         :string
#  hashed_first_name    :string
#  hashed_gender        :string
#  hashed_last_name     :string
#  hashed_phone1        :string
#  hashed_phone2        :string
#  hashed_race          :string
#  hashed_state         :string
#  hashed_zip           :string
#  source_model         :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  hashable_id          :bigint           not null
#  hashed_tenant_id     :string
#  record_id            :bigint           not null, primary key
#
# Indexes
#
#  index_hashed_data_on_hashable  (hashable_type,hashable_id)
#
class HashedDatum < ApplicationRecord
    belongs_to :hashable, polymorphic: true

    # Allow these attributes to be searched through Ransack
  def self.ransackable_attributes(auth_object = nil)
    attributes = %w(
  record_id
  hashable_type
  hashed_address
  hashed_age
  hashed_city
  hashed_country
  hashed_date_of_birth
  hashed_email
  hashed_first_name
  hashed_gender
  hashed_last_name
  hashed_phone1
  hashed_phone2
  hashed_state
  hashed_zip
  hashed_race
  source_model
  created_at
  updated_at
  hashed_tenant_id
) + _ransackers.keys
  end

  # Allow these associations to be searched through Ransack. Can use attributes from different models.
  def self.ransackable_associations(auth_object = nil)
  end

end

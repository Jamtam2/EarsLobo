# app/services/fetch_keys.rb

require 'httparty'
require 'active_support/all'

class FetchKeys
  include HTTParty
  base_uri 'api.dichoticsinc.com/api'

  def self.call
    response = get("/license", query: { apiKey: '[CHANGE API KEY WHEN RUNNING]' })
    if response.success?
      response.parsed_response.each do |data|
        create_key(data) if data['expiration'] && Time.parse(data['expiration']) > Time.now
        
      end
    else
      Rails.logger.error("FetchKeys: Error fetching data - #{response.message}")
    end
  end

  private

  def self.create_key(data)
    key = Key.find_or_initialize_by(license_id: data['licenseID'])
    key.assign_attributes(
      activation_code: data['activationCode'],
      license_type: data['licenseType'],
      expiration: data['expiration'],
      product_id: data['productID'],
      customer_id: data['customerID'],
      subscription_id: data['subscriptiontID']
    )
    key.save if key.new_record? || key.changed?
    puts "This license expires: #{data['expiration']}"
    end
  end

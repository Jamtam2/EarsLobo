# app/services/fetch_keys.rb

require 'httparty'
require 'active_support/all'

class FetchKeys
  include HTTParty
  base_uri 'api.dichoticsinc.com/api'

  def self.call
    response = get("/license", query: { apiKey: 'ears_lobo_audia_dichotic_capstone_winter23' })
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
    Key.find_or_create_by(license_id: data['licenseID']) do |key|
      key.activation_code = data['activationCode']
      key.license_type = data['licenseType']
      key.expiration = data['expiration']
      key.product_id = data['productID']
      key.customer_id = data['customerID']
      key.subscription_id = data['subscriptiontID']
      puts "this license expires: #{data['expiration']}"

    end
  end
end

# frozen_string_literal: true

require 'httparty'

# LicenseDataFetcher
#
# This service is responsible for fetching license data from a remote .NET API.
# The fetched data is filtered to include only licenses that haven't expired yet.
# Each valid license is then persisted to the local Rails database.
#
# Usage:
#   LicenseDataFetcher.call
#
class LicenseDataFetcher
  # .NET rest API endpoint address.
  API_ENDPOINT = 'https://localhost:7010/api/licenses'

  # Calls the service to fetch and store license data.
  #
  # Fetches license data from the specified .NET API endpoint. After parsing the
  # response, it filters out expired licenses. Each valid license is then mapped
  # to the appropriate Rails model fields and persisted to the local database.
  #
  # If the API request fails, it logs an error message with the response content.
  #
  # @return [void]
  def self.call
    response = HTTParty.get(API_ENDPOINT)

    # Ensure the request was successful and has a 200 OK status
    if response.success?
      licenses = JSON.parse(response.body)

      # Filter licenses that haven't expired yet
      valid_licenses = licenses.select do |license_data|
        DateTime.parse(license_data['expiration']) > DateTime.now
      end

      # Save to database or process data as required
      licenses.each do |license_data|
        License(
          product_id: license_data['productID'],
          customer_id: license_data['customerID'],
          subscription_id: license_data['subscriptiontID'].presence || nil, # Default to original NULL if necessary.
          license_type: license_data['licenseType'],
          activation_code: license_data['activationCode'],
          issued_date: DateTime.parse(license_data['createdOnUtc']),
          expiry_date: DateTime.parse(license_data['expiration'])
        )
      end
    else
      # TODO: Handle the error, maybe log it or notify admins.
      Rails.logger.error("Error fetching data from .NET API: #{response.body}")
    end
  end
end

require 'csv'

class LicenseKeyCheckJob < ApplicationJob
  queue_as :default

  def perform
    Key.expired.find_each do |license_key|
      csv_data = generate_csv_data_for(license_key)
      UserMailer.license_key_expired_mail(license_key.user, csv_data).deliver_later
    end
  end

  # private
  def generate_csv_data_for(license_key)
    CSV.generate(headers: true) do |csv|
      csv << ["Key ID", "User ID", "Expiration Date"]
      csv << [license_key.id, license_key.customer_id, license_key.expiration]
    end
  end
end

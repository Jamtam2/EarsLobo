require 'csv'

class LicenseKeyCheckJob < ApplicationJob
  queue_as :default

  def perform(license_key)
    csv_data = generate_csv_data_for(license_key)
    associated_user = license_key.associated_user_by_email
    UserMailer.license_key_expired_mail(associated_user, csv_data).deliver_later if associated_user
  end

  # private
  def generate_csv_data_for(license_key)
    CSV.generate(headers: true) do |csv|

      csv << ["Key ID", "Key Email", "User ID", "User Email", "Expiration Date"]

      associated_user = license_key.associated_user_by_email

      if associated_user
        # dnw_test = associated_user.client_name
        # dwt_test = associated_user.client_name
        # rddt_test = associated_user.client_name

        csv << [license_key.id, license_key.email, associated_user.id, associated_user.email, license_key.expiration]
      else
        csv << [license_key.id, license_key.email, nil, nil, license_key.expiration]
      end
    end
  end
end

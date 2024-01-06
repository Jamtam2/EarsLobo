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
      # Define headers
      headers = ["Test Type", "Tenant ID", "Client ID", "Client Name", "Advantage Percentile",
                 "Ear Advantage", "Ear Advantage Score", "Interpretation", "label",
                 "Left Percentile", "Left Score", "Right Percentile", "Right Score", "Notes", "Test Type",
                 "Created At", "Updated At", "Client ID", "Tenant ID", "User ID"]
      csv << headers

      associated_user = license_key.associated_user_by_email
      return unless associated_user

      # Iterate over each client associated with the user's tenant_id
      associated_user.clients.each do |client|
        # Iterate over DNW tests
        client.dnw_tests.each do |dnw_test|
          csv << ["DNW TEST",
                  client.tenant_id,
                  client.id,
                  dnw_test.client_name,
                  dnw_test.advantage_percentile,
                  dnw_test.ear_advantage,
                  dnw_test.ear_advantage_score,
                  dnw_test.interpretation,
                  dnw_test.label,
                  dnw_test.left_percentile,
                  dnw_test.left_score,
                  dnw_test.right_percentile,
                  dnw_test.right_score,
                  dnw_test.notes,
                  dnw_test.test_type,
                  dnw_test.created_at,
                  dnw_test.updated_at,
                  dnw_test.client_id,
                  dnw_test.tenant_id,
                  dnw_test.user_id]
        end

        # Iterate over DWT tests
        client.dwt_tests.each do |dwt_test|
          csv << ["DWT Test",
                  client.tenant_id,
                  client.id,
                  dwt_test.client_name,
                  dwt_test.advantage_percentile,
                  dwt_test.ear_advantage,
                  dwt_test.ear_advantage_score,
                  dwt_test.interpretation,
                  dwt_test.label,
                  dwt_test.left_percentile,
                  dwt_test.left_score,
                  dwt_test.right_percentile,
                  dwt_test.right_score,
                  dwt_test.notes,
                  dwt_test.test_type,
                  dwt_test.created_at,
                  dwt_test.updated_at,
                  dwt_test.client_id,
                  dwt_test.tenant_id,
                  dwt_test.user_id]
        end

        # Iterate over RDDT tests
        client.rddt_tests.each do |rddt_test|
          csv << ["RDDT TEST",
                  client.tenant_id,
                  client.id,
                  rddt_test.client_name,
                  rddt_test.advantage_percentile,
                  rddt_test.ear_advantage,
                  [rddt_test.ear_advantage_score, rddt_test.ear_advantage_score1, rddt_test.ear_advantage_score3],
                  rddt_test.interpretation,
                  rddt_test.label,
                  rddt_test.left_percentile,
                  [rddt_test.left_score1, rddt_test.left_score2, rddt_test.left_score3],
                  rddt_test.right_percentile,
                  [rddt_test.right_score1, rddt_test.right_score2, rddt_test.right_score3],
                  rddt_test.notes,
                  rddt_test.test_type,
                  rddt_test.created_at,
                  rddt_test.updated_at,
                  rddt_test.client_id,
                  rddt_test.tenant_id,
                  rddt_test.user_id]
        end
      end
    end
  end
end

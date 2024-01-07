class UserMailer < ApplicationMailer
    def license_key_expired_mail(user, csv_data)
      @user = user
      attachments['user_data.csv'] = { mime_type: 'application/octet-stream', content: Base64.encode64(csv_data) }
      mail(to: @user.email, subject: "AIDA: Your License Key Has Expired")
    end

  def send_2fa_code(user, code)
    @user = user
    @code = code
    mail(to: @user.email, subject: 'Your 2FA Code')
  end
end
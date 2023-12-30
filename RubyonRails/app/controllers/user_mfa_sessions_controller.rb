class UserMfaSessionsController < ApplicationController
  skip_before_action :check_mfa, only: [:new, :create]

  def new
    # Initialization code (if any)

  end
  
  def create
    user = current_user
  
    if params[:mfa_code].present?
      secret_key = user.user_mfa_sessions.first.secret_key
      user.google_secret = secret_key
      user.save!
      
      if user.google_authentic?(params[:mfa_code])
        user.user_mfa_sessions.first.update(activated: true)
        redirect_to root_path, notice: "MFA setup successful"
        return
      end
    elsif params[:email_2fa_code].present?
      if params[:email_2fa_code] == user.email_2fa_code
        redirect_to root_path, notice: "2fa setup successful"
        return
      end
    end
  
    # If neither condition is met, it's an invalid code
    attempted_time = Time.now
    server_code = ROTP::TOTP.new(user.user_mfa_sessions.first.secret_key).at(attempted_time) if user.user_mfa_sessions.first.present?
    flash.now[:alert] = "Invalid code. Attempted Code: #{params[:mfa_code] || params[:email_2fa_code]}, Server Code: #{server_code}, Time: #{attempted_time}"
    render :new
  end
  
  def send_email_2fa
    user = current_user
    user.email_2fa_code = SecureRandom.hex(4)
    UserMailer.send_2fa_code(user, user.email_2fa_code).deliver_now
    flash[:notice] = "2FA code sent to your email."
    redirect_to new_user_mfa_session_path
  end
  


  

  private

  def specific_error_message(user, mfa_code)
    if mfa_code.blank?
      "MFA code cannot be blank."
    elsif !user.google_secret.present?
      "MFA setup not completed."
    else
      "Invalid MFA code. Please try again."
    end
  end
end

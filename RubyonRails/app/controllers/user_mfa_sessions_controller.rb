class UserMfaSessionsController < ApplicationController
  skip_before_action :check_mfa, only: [:new, :create]

  def new
    # Initialization code (if any)

  end

  def create
    Rails.logger.debug "DEBUG: STARTS HERE"
    # TODO: remove or comment this this condition before pushing code into production.
    if Rails.env.development?
      redirect_to root_path, notice: "MFA bypassed in development." and return
    else
      Rails.logger.debug "DEBUG: SHOULD NOT RUN THIS"
      user = current_user
      secret_key = user.user_mfa_sessions.first.secret_key
      user.google_secret = secret_key

      user.save!
      if user.google_authentic?(params[:mfa_code])
        user.user_mfa_sessions.first.update(activated: true)
        redirect_to root_path, notice: "MFA setup successful"
      else
        attempted_time = Time.now
        server_code = ROTP::TOTP.new(secret_key).at(attempted_time)
        flash.now[:alert] = "Invalid code. Attempted Code: #{params[:mfa_code]}, Server Code: #{server_code}, Time: #{attempted_time}"
        render :new
      end
    end
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

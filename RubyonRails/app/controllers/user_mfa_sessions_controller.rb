class UserMfaSessionsController < ApplicationController
  skip_before_action :check_mfa, only: [:new, :create]

  def new
    # You might want to initialize the MFA setup here if not done elsewhere
  end

  def create
    user = current_user
    secret_key = user.user_mfa_sessions.first&.secret_key
    user.mfa_secret = params[:mfa_code]
    puts "mfa: #{user.inspect}"

    user.google_secret = secret_key
    

    user.save!
    if user.google_authentic?(params[:mfa_code])
      user.user_mfa_sessions.first.update(activated: true)
      # UserMfaSession.create(user)
      redirect_to root_path, notice: "MFA setup successful"
    else
      flash.now[:alert] = "Invalid code"
      render :new
    end
  end
end
    



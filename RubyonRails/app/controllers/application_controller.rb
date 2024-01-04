class ApplicationController < ActionController::Base


  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user_with_redirect!
  before_action :set_current_tenant
  before_action :check_mfa
  
  def set_current_tenant
    ActsAsTenant.current_tenant = current_user.tenant if current_user
    puts "Current User: #{current_user.inspect}"
    puts "Current Tenant: #{ActsAsTenant.current_tenant.inspect}"
  
  end



  private
  def check_mfa
    return unless user_signed_in? && "/logout" != request.path
  
    # Paths that should bypass MFA check
    mfa_setup_paths = [
      setup_google_auth_user_mfa_sessions_path,
      setup_email_auth_user_mfa_sessions_path,
      enter_email_code_user_mfa_sessions_path,
      verify_email_2fa_user_mfa_sessions_path
    ]
  
    # Bypass MFA check if the current path is one of the MFA setup paths
    return if mfa_setup_paths.include?(request.path)
  
    user_mfa_session = current_user.user_mfa_sessions.first
  
    if user_mfa_session.nil? || (!user_mfa_session.activated && !user_mfa_session.email_verified)
      redirect_to new_user_mfa_session_path
    end
  
    # Additional logic if needed...
  end
  
  
  protected

  def authenticate_user_with_redirect!
    # Redirect user if their license key has expired
    if user_signed_in? && license_key_expired?(current_user)
      flash[:alert] = [] if flash[:alert].nil?
      flash[:alert] << 'Your account license key has expired'
      flash[:alert] << 'Please check your email address.'
      sign_out(current_user)
      redirect_to new_user_session_path and return
    end

    # Skip redirect if this is a devise controller (like registrations) and the action is 'create' or 'new'
    return if devise_controller? && (action_name == 'create' || action_name == 'new')

    # Redirect to login page if not signed in
    if !user_signed_in?
      redirect_to new_user_session_path and return
    end
  end


  # Validate user login by verifying if the license key expiration date is less than the current date.
  # params:
  #         user - current user attempting an action
  # return:
  #         false - if no license key is found
  #         license_key - if a license key is found
  def license_key_expired?(user)
    license_key = user.license_key
    return false unless license_key

    license_key.expiration < DateTime.current
  end


  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:fname, :lname, :email, :password, :password_confirmation, :registration_key])
  end
end

 



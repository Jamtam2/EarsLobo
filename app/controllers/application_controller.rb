class ApplicationController < ActionController::Base
  before_action :root_directory
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_current_tenant
  before_action :check_mfa
  before_action :authenticate_user_with_redirect!, unless: :mfa_process?

  
  def set_current_tenant
    ActsAsTenant.current_tenant = current_user.tenant if current_user
    puts "Current User: #{current_user.inspect}"
    puts "Current Tenant: #{ActsAsTenant.current_tenant.inspect}"
  
  end


  
  def root_directory
    if !user_signed_in?
      
      requested_path = request.fullpath

      allowed_paths = ["/users/sign_in", "/users/sign_up", "/users", "/stripe_checkout","/webhooks/stripe", "/users/password/new", "/users/password", "/users/password/edit", "/inquiries"] + mfa_setup_paths
      is_allowed_path = allowed_paths.any? { |path| requested_path.start_with?(path) }

      return if is_allowed_path
      
      redirect_to new_user_session_path 
    end
  end
  private

  def check_mfa
    # Bypass MFA check in development
    if Rails.env.development?
      return
    end
    
    # TODO: Remove this when moving to production
    # if Rails.env.development?
    #   return
    # end

    return unless user_signed_in? && "/users/sign_out" != request.path

    # Bypass MFA check if the current path is one of the MFA setup paths
    return if mfa_setup_paths.include?(request.path)
  
    user_mfa_session = current_user.user_mfa_sessions.first
  
    if user_mfa_session.nil? || (!user_mfa_session.activated && !user_mfa_session.email_verified)
      redirect_to new_user_mfa_session_path and return
    
    else
      authenticate_user_with_redirect!
      
    end
  
    # Additional logic if needed...
  end
  protected

  def authenticate_user_with_redirect!
    if request.path == "/users/sign_out" 
      sign_out(current_user)
      redirect_to new_user_session_path and return
    end
    
    if mfa_setup_paths.include?(request.path)
      Rails.logger.info("DEBUG:THIS IS THE PATH: #{request.path}")
      return
    end
    if user_signed_in? && license_key_expired?(current_user)
      Rails.logger.info("DEBUG: USER SIGNED IN AND KEY IS EXPIRED: #{current_user.inspect}")
      Rails.logger.info("DEBUG: KEY INFO: #{current_user.license_key.inspect}")


      if [clients_path(format: "csv") ,expired_license_path,update_registration_key_path].include?(request.path)
        Rails.logger.info("DEBUG: GOT IN REQUEST PATH")
        return
      else
        flash[:alert] = [] if flash[:alert].nil?
        flash[:alert] << 'Your account license key has expired'
        # sign_out(current_user)
        redirect_to expired_license_path and return
      end
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
    Rails.logger.info("KEY IN EXPIRATION METHOD: #{license_key.inspect}")

    license_key.expiration < DateTime.current
  end

  def mfa_process?
    # Define the logic to determine if the user is in the MFA process
    user_signed_in? && !mfa_setup_paths.include?(request.path)
  end


  def mfa_setup_paths
    # List of paths for MFA setup
    [
      setup_google_auth_user_mfa_sessions_path,
      setup_email_auth_user_mfa_sessions_path,
      enter_email_code_user_mfa_sessions_path,
      verify_email_2fa_user_mfa_sessions_path,
      "/stripe_checkout",
      "/stripe_checkout/success",
    ]
  end


  protected

  # TODO: Because this requires a moderator_code, regular and global users will need have set special way to bypass this.
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:fname, :lname, :email, :password, :password_confirmation, :verification_key, :moderator_code])
  end
end

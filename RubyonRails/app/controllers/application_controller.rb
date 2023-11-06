class ApplicationController < ActionController::Base
  
  
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user_with_redirect!
  before_action :set_current_tenant
  
  def set_current_tenant
    ActsAsTenant.current_tenant = current_user.tenant if current_user
    Rails.logger.debug("[DEBUG] Current User: #{current_user.inspect}")
    Rails.logger.debug("[DEBUG] Current Tenant: #{current_tenant.inspect}")
  end

  protected
  def authenticate_user_with_redirect!
    if current_user
      sign_in(current_user, event: :authentication)
    elsif !devise_controller? || action_name != 'new'
      redirect_to new_user_session_path
    end
  end
end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:fname, :lname])
    devise_parameter_sanitizer.permit(:account_update, keys: [:fname, :lname])
  end


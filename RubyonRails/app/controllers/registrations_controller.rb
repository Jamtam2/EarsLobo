# The registration form's fields are dynamically updated based on the selected account type.
# See corresponding JavaScript in app/assets/javascripts/accountSignupButtons.js

# RegistrationsController handles user registration for different roles
# including regular users and local moderators. It includes custom logic
# for validating registration keys and moderator codes.
class RegistrationsController < Devise::RegistrationsController

  # create: Determines the type of user account to be created based on
  # the 'account_type' parameter and delegates to the appropriate method.
  def create
    case params[:account_type]
    when 'regular_user'
      create_regular_user
    when 'local_moderator'
      create_local_moderator
    else
      flash[:alert] = 'Invalid account type.'
      redirect_to new_user_registration_path and return
    end
  end

  # create_regular_user: Creates a regular user account. Requires a valid
  # local moderator code and a registration key. Associates the user with
  # a local moderator's tenant_id.
  def create_regular_user
    # The moderator code will be used for validation but will not be be stored under regular use.
    user = User.new(sign_up_params.except(:moderator_code))
    user.role = :regular_user
    local_moderator = User.find_by(role: User.roles[:local_moderator], moderator_code: params[:user][:moderator_code])
    # Validate the registration key for security purposes.
    key = Key.find_by(activation_code: user.registration_key)

    if local_moderator.present? && valid_registration_key?(key)
      # The user is associated with the tenant of the local moderator whose code was entered.
      user.tenant_id = local_moderator.tenant_id

      # Check if user record was saved before proceeding.
      if user.save
        key.update(used: true)
        flash[:notice] = 'Regular user was successfully created.'
        sign_in(:user, user)
        redirect_to root_path, notice: 'User was successfully created set up 2FA auth.'
      else
        # If user creation fails, render the registration form again with error messages.
        flash.now[:alert] = user.errors.full_messages.join(', ')
        render :new
      end
    else
      flash[:alert] = 'Invalid moderator code or registration key.'
      redirect_to new_user_registration_path and return
    end
  end

  # create_local_moderator: Creates a local moderator account. Requires a
  # valid, unused registration key. Creates a new tenant for the moderator.
  def create_local_moderator
    tenant = Tenant.create!

    ActsAsTenant.with_tenant(tenant) do
      user = User.new(sign_up_params) # Initialize new user
      user.role = :local_moderator    # Set the role
      key = Key.find_by(activation_code: user.registration_key)

      if valid_registration_key?(key)
        # Save the user, which will trigger before_create callback
        if user.save
          # Handler for successful save actions
          key.update(used: true, email: user.email)
          user.verification_key = key.activation_code
          secret_key = ROTP::Base32.random_base32
          user.user_mfa_sessions.create!(secret_key: secret_key, activated: false)
          sign_in(:user, user)
          redirect_to root_path, notice: 'Local moderator was successfully created set up 2FA auth.'
        else
          # Handler for save failures
          flash[:alert] = 'An internal error occurred.'
          Rails.logger.info("DEBUG: Failed to save user: #{user.errors.full_messages}")
          redirect_to new_user_registration_path and return
        end
      else
        # Handler for save failures
        flash[:alert] = 'Invalid registration key.'
        redirect_to new_user_registration_path and return
      end
    end
  end

  private

  def valid_registration_key?(key)
    key.present? && !key.used && (key.expiration.nil? || key.expiration > Time.current)
  end

  private

  def sign_up_params
    allowed_params = [:fname, :lname, :email, :password, :password_confirmation, :registration_key]
    allowed_params << :moderator_code if params[:account_type] == 'regular_user'
    params.require(:user).permit(allowed_params)
  end

end

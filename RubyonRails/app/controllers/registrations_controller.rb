class RegistrationsController < Devise::RegistrationsController

  def create
      # TODO: This was crashing app before, commented out.
      # In registration form, user selects regular or local mod
      # if user.regular
      # # do something here
      # end
      #
      # if user.local_moderator
      # end

      tenant = Tenant.create!
      user = nil
      ActsAsTenant.with_tenant(tenant) do
        user = User.new(sign_up_params) # Initialize new user
        user.role = :local_moderator    # Set the role
        key = Key.find_by(activation_code: user.registration_key)

        if valid_registration_key?(key)
          # Save the user, which will trigger before_create callback
          if user.save
            key.update(used: true, email: user.email)
            user.verification_key = key.activation_code
            secret_key = ROTP::Base32.random_base32
            user.user_mfa_sessions.create!(secret_key: secret_key, activated: false)
            sign_in(:user, user)
            redirect_to root_path, notice: 'User was successfully created set up 2FA auth.'
          else
            flash[:alert] = 'An internal error occured.'
            Rails.logger.info("DEBUG: Failed to save user: #{user.errors.full_messages}")
            redirect_to new_user_registration_path and return
          end
        else
          flash[:alert] = 'Invalid registration key.'
          redirect_to new_user_registration_path and return
        end
      end
  end

  private

  def valid_registration_key?(key)
    key.present? && !key.used && (key.expiration.nil? || key.expiration > Time.current)
  end

end

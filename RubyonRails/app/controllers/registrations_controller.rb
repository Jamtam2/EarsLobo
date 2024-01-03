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


    tenant = Tenant.create!  # Ensure this line is creating a tenant
    user = nil
    ActsAsTenant.with_tenant(tenant) do
      user = User.create!(sign_up_params)
    end

    # Check the registration key validity
    key = Key.find_by(activation_code: user.registration_key)

    if valid_registration_key?(key)
      key.update(used: true)
      key.update(email: user.email)
      user.verification_key = key.activation_code
      user.role = :local_moderator
      # Sign in the user and redirect to the homepage if successful login
      if user.save
        secret_key = ROTP::Base32.random_base32 # Generate a random secret key
        user.user_mfa_sessions.create!(secret_key: secret_key, activated: false)
        puts "Key has been paired with user: #{key.inspect}"
        puts "User: #{user.inspect}"
        sign_in(:user, user)
        redirect_to root_path, notice: 'User was successfully created set up 2FA auth.'
      end

    else
      flash[:alert] = 'Invalid registration key.'
      redirect_to new_user_registration_path and return
    end
  end

  private

  def valid_registration_key?(key)
    key.present? && !key.used && (key.expiration.nil? || key.expiration > Time.current)
  end

end

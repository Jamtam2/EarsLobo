class RegistrationsController < Devise::RegistrationsController
  def create
    tenant = Tenant.create!  # Ensure this line is creating a tenant
    user = nil
    ActsAsTenant.with_tenant(tenant) do
      user = User.create!(sign_up_params)
    end

    # Check the registration key validity
    key = Key.find_by(activation_code: user.registration_key)

    if valid_registration_key?(key)
    
      user.role = :local_moderator

      # Sign in the user and redirect to the homepage if successful login
      if user.save
        user.verification_key = key.activation_code
        key.update(used: true)
        key.update(email: user.email)
        puts "Key has been paired with user: #{key.inspect}"
        puts "User: #{user.inspect}"
        sign_in(:user, user)
        redirect_to root_path, notice: 'User was successfully created and signed in.'
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

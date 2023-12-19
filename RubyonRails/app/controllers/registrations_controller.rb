class RegistrationsController < Devise::RegistrationsController
  def create
    build_resource(sign_up_params)  # Build the user object with permitted parameters

    # Validate registration key and set up tenant before saving the user
    key = Key.find_by(activation_code: resource.registration_key)
    # puts "DEBUG: Tenant_id: #{tenant.inspect}"
    if valid_registration_key?(key)
      tenant = Tenant.create!  # Ensure this line is creating a tenant
      puts "DEBUG_tenant: Tenant_id: #{tenant.id}"
      resource.tenant = tenant
      puts "DEBUG: #{tenant.id}"
      puts "DEBUG_rt: Tenant_id: #{resource.tenant}"
      resource.role = :local_moderator
    else
      flash[:alert] = 'Invalid registration key.'
      redirect_to new_user_registration_path and return
    end

    # Save the user with Devise's original logic
    super
  end

  private

  def valid_registration_key?(key)
    key.present? && !key.used && (key.expiration.nil? || key.expiration > Time.current)
  end
end

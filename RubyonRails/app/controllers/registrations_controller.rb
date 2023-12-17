class RegistrationsController < Devise::RegistrationsController
  def create
    super do |user|
      if user.persisted?
        key = Key.find_by(activation_code: user.registration_key)
        if valid_registration_key?(key)
          tenant = Tenant.create!
          user.update(tenant_id: tenant.id, role: 'local_moderator')
          key.update(used: true)
        else
          user.destroy # Optional: Destroy the user if the key is invalid
          flash[:alert] = 'Invalid registration key.'
          redirect_to new_user_registration_path and returnc
        end
      end
    end
  end

  private
  def valid_registration_key?(key)
    key.present? && !key.used && (key.expiration.nil? || key.expiration > Time.current)
  end
end

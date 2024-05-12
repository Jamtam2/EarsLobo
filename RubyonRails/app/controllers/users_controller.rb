class UsersController < ApplicationController
  before_action :check_permission, only: [:new, :create]

  def index

    if current_user.global_moderator?
      local_users = User.unscoped { User.all }
      # @users = User.unscoped { User.all }
    else
      local_users = User.where(tenant_id: current_user.tenant_id)
      # @users = User.where(tenant_id: current_user.tenant_id)
  end 
    if params[:query]
      split_query = params[:query].split(' ')
      if split_query.length > 1
        # Case when both first name and last name are typed
        @users = local_users.where('lower(fname) LIKE :first AND lower(lname) LIKE :last', 
                            first: "#{split_query.first.downcase}%", 
                            last: "#{split_query.last.downcase}%")
      else
        # Case when either first name, last name, or email is typed
        @users = local_users.where('lower(fname) LIKE :query OR lower(lname) LIKE :query OR lower(email) LIKE :query', 
                            query: "%#{params[:query].downcase}%")
      end
    else
      @users =local_users
      #@users = User.where(tenant_id: current_user.tenant_id)
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    key = Key.find_by(activation_code: params[:registration_key])
  
    # Rails.logger("DEBUG: User: #{@user.inspect}")
    # Rails.logger("DEBUG: key: #{key.inspect}")
  
    if valid_registration_key?(key)
      # Rails.logger("DEBUG: KEY IS VALID!!!")
  
      tenant = Tenant.create!
      # Rails.logger("DEBUG: Created tenant #{tenant.inspect}")
      @user.tenant_id = tenant.id
      @user.role = 'local_moderator'
  
      # Rails.logger("DEBUG: tenant_id: #{@user.tenant_id.inspect}")
      # Rails.logger("DEBUG: user role: #{@user.role.inspect}")
  
      if @user.save
        # Rails.logger("DEBUG: Saving user: #{@user.inspect}")
  
  
        # key.update(used: true)
        # User, tenant, and key update successful
        puts "New user (local moderator) was saved with Tenant ID: #{tenant.id}"
      else
        # Handle user creation failure
        puts "Failed to create user"
        Rails.logger("DEBUG: FAILED TO CREATE USER: #{@user.role.inspect}")
        render :new
      end
    else
      # Handle invalid key
      flash[:alert] = 'Invalid registration key.'
      render :new
    end
  end

  private

  def valid_registration_key?(key)
    key.present? && !key.used && (key.expiration.nil? || key.expiration > Time.current)
  end

  private

  def check_permission
    unless current_user.local_moderator? || current_user.global_moderator?
      redirect_to users_path, alert: "You don't have permission to perform this action."
    end
  end

  def user_params
    params.require(:user).permit(:fname, :lname, :email, :password, :password_confirmation, :tenant_id, :registration_key)
    Rails.logger("DEBUG: #{@user.email.inspect}")
  end
end
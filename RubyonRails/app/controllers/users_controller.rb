class UsersController < ApplicationController
  before_action :check_permission, only: [:new, :create]

  def index
    local_users = User.where(tenant_id: current_user.tenant_id)

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
      @users = User.where(tenant_id: current_user.tenant_id)
    end
  end

  def new
    @user = User.new
    render :new
  end


  def create
    @user = User.new(user_params)
    key = Key.find_by(activation_code: params[:registration_key])
  
    if valid_registration_key?(key) || params[:role] == 'local_moderator'
      if params[:role] == 'local_moderator'
        tenant = Tenant.create!  # Create tenant for local moderator
        @user.tenant_id = tenant.id
      end
  
      if @user.save
        # Optional: key.update(used: true)
        puts "New user (local moderator) was saved with Tenant ID: ##{tenant.id}"
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
  def destroy
    debugger
    @user = User.find(params[:id])
    @user.destroy

    redirect_to clients_url, notice: "client was successfully deleted."
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

  # def assign_location_moderator
  #   @user = User.find(params[:id])
  #   @location = Location.find(params[:id])
  #
  #   if @user.location_moderator?
  #     @location.users << @user unless @location.users.include?(@user)
  #     flash[:notice] = "Location moderator assigned successfully."
  #   else
  #     flash[:alert] = "Only location moderators can be assigned."
  #   end
  # end
end
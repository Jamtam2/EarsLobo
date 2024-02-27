class LocationsController < ApplicationController


  before_action :authorize_local_moderator, only: [:create]

  def new
    @location = Location.new
    # Ensure @users only includes location moderators if the current user is a local moderator
    @users = local_moderator? ? User.where(role: :location_moderator) : User.all
  end

  def create
    @location = Location.new(location_params)
    if @location.save
      puts "Location saved with ID: #{@location.id}"
      puts "Assigned user IDs: #{@location.user_ids}"
      puts "Users associated with location: #{@location.users.inspect}"
      assign_moderators_to_location(params[:location][:user_ids])
      flash[:notice] = 'Location was successfully created.'
      puts "Before redirect"
      redirect_to users_path
    else
      @users = User.all
      render :new
    end
  end

  private

  def authorize_local_moderator
    unless current_user.local_moderator?
      flash[:alert] = 'You are not authorized to perform this action.'
      redirect_to root_path # Or another appropriate path
    end
  end

  def location_params
    params.require(:location).permit(:name, :address, user_ids: [])
  end

  def assign_moderators_to_location(user_ids)
    users = User.where(id: user_ids, role: :location_moderator)
    @location.users << users
  end

  def local_moderator?
    current_user.role == 'local_moderator'
  end
end

class LocationsController < ApplicationController
  #before_action :set_location, only: [:show, :edit, :update, :destroy]

  def new
    @location = Location.new
    @users = User.all
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

  def set_location
    @location = Location.find(params[:id])
  end

  def location_params
    params.require(:location).permit(:name, :address, user_ids: [])
  end

  def assign_moderators_to_location(user_ids)
    #return unless user_ids.present?

    users = User.where(id: user_ids)
    @location.users << users  # Assign users to the location directly
  end
end
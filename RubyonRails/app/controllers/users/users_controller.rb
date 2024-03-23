module Users
  class UsersController < ApplicationController
    def index
      @users = User.all
      render :home
    end
  end
end

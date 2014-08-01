class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :finish_signup]
  before_action :authenticate_user!, only: [:show]

  respond_to :html, :json

  def show
    if current_user != @user
      # creates a match using a comparison spotify data for each user
      @match = Matcher.new(current_user, @user)
    end
  end

  def finish_signup
    if request.patch? && params[:user]
      if @user.update(user_params)
        sign_in(@user, :bypass => true)
        redirect_to root_path
      else
        @show_errors = true
      end
    end
  end

  def update
    if @user.update(user_params)
      sign_in(@user == current_user ? @user : current_user, :bypass => true)
      redirect_to root_path
    else
      redirect_to root_path
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email,:uid,:remote_image_url,:image,:name,:age,:gender,:interested_in,:display_name,:location,:bio)
  end

end

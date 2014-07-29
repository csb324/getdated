class FavoritesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  def index
    # favourited users associated with current user
    @favorites = @user.favorites
  end

  def create
    @favorite = Favorite.new
    @favorite.user_1 = current_user.id
    # User_2 is target user
    fav_target = params[:user_2_id].key('')
    @favorite.user_2 = fav_target

    if @favorite.save
      redirect_to :back
    else
      redirect_to :back
    end
  end

  private

  def set_user
    @user = current_user
  end

  def favorite_params
    params.require(:favorite).permit(:user_1, :user_2, :liked_back, :id)
  end

end

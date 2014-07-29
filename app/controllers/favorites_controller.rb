class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def index
    # favourited users associated with current user
    @favorites = current_user.favorites
  end

  def create
    # @favorited_user = current_user.favorites.create(params[:user_id])
    # @user.favorites << @favorited_user
  end

  private

  def favorite_params
    params.require(:favorite).permit(:user_1, :user_1, :liked_back, :id)
  end

end

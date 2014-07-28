class FavoritesController < ApplicationController
  before_action :authenticate_user! only: [:new, :create]

  def index
    # favourited users associated with current user
    @favorites = @user.favorites
  end

  def create
    @favorited_user = current_user.favorites.create(params[:user_id])
    @user.favorites << @favorited_user
  end

end

class FavoritesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  def index
    @target_users = []
    # favourited users associated with current user mutually liked
    @favorites = Favorite.where(fav_initiator: @user, liked_back: true)
    @favorites += Favorite.where(fav_receiver: @user, liked_back: true)

    # @favorites.each do |favorite|
    #   @target_users << favorite.other_user(@user)
    # end

  end

  def show
    @favorite = Favorite.find_by(params[:id])
  end

  def create
    @target = User.find(params[:target_id])
    @favorite = Favorite.find_by(fav_initiator: @target, fav_receiver: @user)

    if @favorite
      @favorite.liked_back = true
    else
      @favorite = Favorite.new(fav_initiator: @user, fav_receiver: @target)
    end

    # @favorite.user_1 = current_user.id
    # # User_2 is target user
    # fav_target = params[:user_2_id].key('')
    # @favorite.user_2 = fav_target

    if @favorite.save
      redirect_to user_path(@target), notice: "You did the thing!"
    else
      redirect_to user_path(@target), notice: "that didn't work for some reason"
    end

  end

  private

  def set_user
    @user = current_user
  end

  def favorite_params
    params.require(:favorite).permit(:user_1, :user_2, :liked_back)
  end

end

class FavoritesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  respond_to :json

  def index
    @target_users = []
    # favourited users associated with current user when mutually liked
    @favorites = Favorite.where(fav_initiator: @user, liked_back: true)
    @favorites += Favorite.where(fav_receiver: @user, liked_back: true)
  end

  def show
    @favorite = Favorite.find(params[:id])
    @messages = Message.where(favorite: @favorite).reverse
    @messages.each do |msg|
      if msg.user != current_user
        msg.read = true
        msg.save
      end
    end
  end

  def create
    @target = User.find(favorite_params[:fav_receiver])
    @favorite = Favorite.find_by(fav_initiator: @target, fav_receiver: current_user)

    if @favorite
      @favorite.liked_back = true
    else
      @favorite = Favorite.new(fav_initiator: current_user, fav_receiver: @target)
    end

    if @favorite.save
      respond_with(@favorite)
    else
      respond_with(@favorite.errors)
    end
  end

  private

  def set_user
    @user = current_user
  end

  def favorite_params
    params.require(:favorite).permit(:fav_initiator, :fav_receiver)
  end

end

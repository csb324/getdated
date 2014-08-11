class FavoritesController < ApplicationController
  before_action :authenticate_user!

  respond_to :json

  def index
    @target_users = []
    # favourited users associated with current user when mutually liked
    @favorites = Favorite.where(fav_initiator: current_user, liked_back: true).includes(:fav_initiator)
    @favorites += Favorite.where(fav_receiver: current_user, liked_back: true).includes(:fav_receiver)
  end

  def show
    # Also shows all messages between matched users
    @favorite = Favorite.find(params[:id])
    @messages = Message.includes(:user).where(favorite: @favorite).sort()
    # gets the user who is not current user in the match
    @mylove = @favorite.other_user(current_user)
    @match = Matcher.new(current_user, @mylove)

    # Marks messages as read or unread so they get notifications in
    # the nav bar
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
      # sends a message if both users like each other
      @favorite.liked_back = true
      @message = Message.new(user: current_user)
      @message.favorite = @favorite
      @message.msg = "Congratulations! It's a match!"
      @message.save
    else
      # otherwise it initiates a favorite
      @favorite = Favorite.new(fav_initiator: current_user, fav_receiver: @target)
    end

    # for Ajax post responses
    if @favorite.save
      respond_with(@favorite)
    else
      respond_with(@favorite.errors)
    end
  end

  private
  # LEFT SIDE -- STRONG SIDE .. params
  def favorite_params
    params.require(:favorite).permit(:fav_initiator, :fav_receiver)
  end

end

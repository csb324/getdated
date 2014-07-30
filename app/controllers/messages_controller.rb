class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  def index
    @messages = current_user.messages#.sort(created_at: :desc)
  end

  def show
    # only show for current user
  end

  def new
    @message = Message.new
  end

  def create
    @message = Message.new(message_params)
    @favorite = Favorite.find(params[:message][:favorite_id])
    @message.favorite = @favorite
    @message.user = current_user

    if @message.save
      redirect_to @favorite, notice: "You're pretty"
      flash[:notice] = "Cunty McCunterson"
    else
      # redirect_to favorite_path(@favorite) notice: "yeah... nah."
      flash[:notice] = "Yeah... nah"
    end
  end

  def update
    # Ajax calls
    # - when user submits
    # - user leaves or rejoins
  end

  private
  # def set_favorite
  #   @favorite = Favorite.find(params[:id])
  # end
  def set_user
    @user = current_user
  end
  def message_params
    params.require(:message).permit(:sender_id, :msg)
  end
end

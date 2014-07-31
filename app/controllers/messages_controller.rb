class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

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
    else
      redirect_to favorite_path(@favorite), notice: "Sorry Buddy something went wrong"
    end
  end

  private
  def set_user
    @user = current_user
  end
  def message_params
    params.require(:message).permit(:msg)
  end
end

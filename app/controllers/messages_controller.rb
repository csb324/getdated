class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  respond_to :json

  def new
    @message = Message.new
  end

  def create
    @message = Message.new(message_params)
    @favorite = Favorite.find(params[:message][:favorite_id])
    @message.favorite = @favorite
    @message.user = current_user

    if @message.save
      respond_with(@favorite)
    else
      respond_with(@favorite.errors)
    end
  end

  private
  def set_user
    @user = current_user
  end
  def message_params
    params.require(:message).permit(:msg, :favorite_id)
  end
end

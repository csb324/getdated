class MessagesController < ApplicationController
  before_action :authenticate_user!

  respond_to :json

  def new
    @message = Message.new
  end

  # Done with an Ajax call
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

  def message_params
    params.require(:message).permit(:msg, :favorite_id)
  end
end

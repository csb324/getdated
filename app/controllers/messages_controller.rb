class MessagesController < ApplicationController
  before_action :authenticate_user!

  def index
    @messages = current_user.Message.all.sort(created_at: :desc)
  end

  def show
    # only show for current user
  end

  def new

  end

  def create

  end

  def update
    # Ajax calls
    # - when user submits
    # - user leaves or rejoins
  end

  private

  def message_params
    params.require(:message).permit(:sender_id, :create_at, :msg, :favorite_id)
  end
end

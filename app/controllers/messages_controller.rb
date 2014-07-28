class MessagesController < ApplicationController
  before_action :authenticate_user!

  def show
    # only show for current user
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

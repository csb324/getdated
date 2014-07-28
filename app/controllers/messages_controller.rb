class MessagesController < ApplicationController
  before_action :authenticate_user! only: [:new, :create]

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
    params.require(:message).permit(:user1_id, :user2_id, :user1_response, :user2_response, :content)
  end
end

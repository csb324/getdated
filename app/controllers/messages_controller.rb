class MessagesController < ApplicationController
  before_action :authenticate_user! only: [:new, :create]

  def index
  end

end

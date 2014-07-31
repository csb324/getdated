class Message < ActiveRecord::Base
  belongs_to :user
  belongs_to :favorite

  validates :msg, presence: true

  def mark_as_read
    read = true
  end

  def message_class(me)
    if me == user
      "sent"
    else
      "received"
    end
  end


end

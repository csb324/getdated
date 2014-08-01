class Favorite < ActiveRecord::Base
  has_many :messages
  belongs_to :fav_initiator, :class_name => "User"
  belongs_to :fav_receiver, :class_name => "User"

  # So you can't multi-favorite someone or favorite yourself
  validates :fav_initiator, uniqueness: { scope: :fav_receiver,
    message: "You can only like them so much! " }
  validates :fav_receiver, uniqueness: { scope: :fav_initiator,
    message: "You can only like them so much! " }


  def other_user(current_user)
    if fav_initiator == current_user
      fav_receiver
    else
      fav_initiator
    end
  end

  def unread_messages(current_user)
    messages.select{ |msg| msg.read == false && msg.user != current_user}
  end

  def is_unread?(current_user)
    unread_messages(current_user).length != 0
  end

  def most_recent_unread(current_user)
    unread_messages(current_user).sort_by{ |msg| msg.created_at }.last
  end

end

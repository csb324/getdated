class Favorite < ActiveRecord::Base
  has_many :messages
  belongs_to :fav_initiator, :class_name => "User"
  belongs_to :fav_receiver, :class_name => "User"

  def other_user(me)
    if fav_initiator == me
      fav_receiver
    else
      fav_initiator
    end
  end

end

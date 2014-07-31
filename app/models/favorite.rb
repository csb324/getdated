class Favorite < ActiveRecord::Base
  has_many :messages
  belongs_to :fav_initiator, :class_name => "User", dependent: :destroy
  belongs_to :fav_receiver, :class_name => "User", dependent: :destroy

  # So you can't multi-favorite someone or favorite yourself
  validates :fav_initiator, uniqueness: { scope: :fav_receiver,
    message: "You can only like them so much! " }
  validates :fav_receiver, uniqueness: { scope: :fav_initiator,
    message: "You can only like them so much! " }


  def other_user(me)
    if fav_initiator == me
      fav_receiver
    else
      fav_initiator
    end
  end

end

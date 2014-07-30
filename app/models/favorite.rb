class Favorite < ActiveRecord::Base
  has_many :messages
  belongs_to :fav_initiator, :class_name => "User"
  belongs_to :fav_receiver, :class_name => "User"
  validates :fav_initiator, uniqueness: { scope: :fav_receiver,
    message: "You can only like them so much! " }
end

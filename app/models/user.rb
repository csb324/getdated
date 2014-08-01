class User < ActiveRecord::Base

  mount_uploader :image, AvatarUploader

  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable,
  :omniauthable, :omniauth_providers => [:spotify]

  validates :email, uniqueness: true
  validates :display_name, uniqueness:true

  # list of cities you can select from
  CITIES = [['Atlanta, GA', 'atlanta'], ['Boston, MA', 'boston'],['Denver, CO','denver'],
   ['Las Vegas, NV','lasvegas'],['Los Angeles, CA','losangeles'],
   ['Miami, FL','miami'],['New York, NY','newyork'],
   ['Portland, OR', 'portland'], ['Raleigh, NC', 'raleigh'],
   ['San Francisco, CA', 'sanfrancisco'],['San Diego, CA', 'sandiego'],
   ['Seattle, WA', 'seattle'],['Washington, D.C.','washington']]

  has_and_belongs_to_many :tracks
  has_many :favorites_sent, class_name: "Favorite", foreign_key: :fav_initiator_id
  has_many :favorites_received, class_name: "Favorite", foreign_key: :fav_receiver_id
  has_many :messages_sent, class_name: "Message"
  has_many :artists, through: :tracks
  has_many :genres, through: :artists

  def favorites
    favorites_sent + favorites_received
  end

  ## some methods that have to do with messages
  def messages
    msgs = []
    favorites.each do |fav|
      fav.messages.each do |message|
        msgs << message
      end
    end
    msgs
  end

  def messages_received
    sent_array = []
    messages_sent.each do |msg|
      sent_array << msg
    end
    messages - sent_array
  end

  def unread_messages
    unread = []
    messages_received.each do |msg|
      if msg.read == false
        unread << msg
      end
    end
    unread
  end

  def unread_count
    unread_messages.length
  end

  # gets information back through Users spotify account
  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_create do |user|
      if auth.info.email?
        user.email = auth['info']['email']
      else
        user.email = "12324857203948572304857230948750923847509283475@example.com"
      end
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name # assuming the user model has a name
      user.uid = auth.uid
      user.provider = auth.provider

      user.update(remote_image_url: auth['info']['image'] || "http://thumbs.dreamstime.com/z/grooving-puppy-3978556.jpg")
    end
  end


  def match_with(other_person)
    Matcher.new(self, other_person).score
  end

  # for working out match score by option
  def frequencies_of(option)
    frequencies = Hash.new(0)
    if option == :artists
      artists.each do |artist|
        frequencies[artist] += 1
      end
      frequencies
    elsif option == :genres
      genres.each do |genre|
        frequencies[genre] += 1
      end
      frequencies
    elsif option == :tracks
      tracks.each do |track|
        frequencies[track] += 1
      end
      frequencies
    end
  end

  def favorite_music(option)
    my_faves = []
    freq_descending = frequencies_of(option).sort_by{ |item, count| count }.reverse
    freq_descending[0...5].each do |fav|
      my_faves << fav[0].name
    end
    my_faves.shuffle[0...3]
  end

  # called from Home#index
  def potential_matches
    potentials = []
    User.where(location: location).find_each do |user|
      if interested_in == "both" || interested_in == user.gender
        if user.interested_in == "both" || user.interested_in == gender
          potentials << user unless user == self
        end
      end
    end
    potentials
  end

  
  def favorite_exists?(other_user)
    if Favorite.find_by(fav_initiator: other_user, fav_receiver: self)
      true
    elsif Favorite.find_by(fav_receiver: other_user, fav_initiator: self, liked_back: true)
      true
    else
      false
    end
  end

#Favourite Button doesn't show up for self or already favourited
  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.spotify_data"] && session["devise.spotify_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

end

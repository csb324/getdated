class User < ActiveRecord::Base

  mount_uploader :image, AvatarUploader

  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable,
  :omniauthable, :omniauth_providers => [:spotify]

  validates :email, uniqueness: true
  validates :display_name, uniqueness: true

  CITIES = [['Atlanta, GA', 'atlanta'], ['Boston, MA', 'boston'],['Denver, CO','denver'],
   ['Las Vegas, NV','lasvegas'],['Los Angeles, CA','losangeles'],
   ['Miami, FL','miami'],['New York, NY','newyork'],
   ['Portland, OR', 'portland'], ['Raleigh, NC', 'raleigh'],
   ['San Francisco, CA', 'sanfrancisco'],['San Diego, CA', 'sandiego'],
   ['Seattle, WA', 'seattle'],['Washington, D.C.','washington']]

  has_and_belongs_to_many :tracks
  has_many :favorites, foreign_key: 'fav_initiator_id', dependent: :destroy
  has_many :artists, through: :tracks
  has_many :genres, through: :artists

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

  def potential_matches
    potential_matches = User.where(location: location)
    if interested_in != "both"
      potential_matches = potential_matches.select do |user|
        user.gender == interested_in
      end
    end
    potential_matches = potential_matches.select do |user|
      if user.interested_in == "both"
        true
      else
        user.interested_in == gender
      end
    end
    potential_matches
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.spotify_data"] && session["devise.spotify_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

end

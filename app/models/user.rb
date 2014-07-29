class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable,
  :omniauthable, :omniauth_providers => [:spotify]
  validates :email, uniqueness: true

  CITIES = [['Atlanta, GA', 'atlanta'], ['Boston, MA', 'boston'],['Denver, CO','denver'],
   ['Las Vegas, NV','lasvegas'],['Los Angeles, CA','losangeles'],
   ['Miami, FL','miami'],['New York, NY','newyork'],
   ['Portland, OR', 'portland'], ['Raleigh, NC', 'raleigh'],
   ['San Francisco, CA', 'sanfrancisco'],['San Diego, CA', 'sandiego'],
   ['Seattle, WA', 'seattle'],['Washington, D.C.','washington']]

  has_many :tracks, dependent: :destroy

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
      user.image = auth['info']['image']
      user.provider = auth.provider
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.spotify_data"] && session["devise.spotify_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

end

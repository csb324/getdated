class Track < ActiveRecord::Base

  belongs_to :user

  def create
    @track = Track.new(track_params)
  end

  def self.refresh(credentials, current_user)
    @auth_token = "Bearer #{credentials}"
    playlists_json_string = RestClient::Request.execute(
      :method => :get,
      :url => "https://api.spotify.com/v1/users/#{current_user.uid}/playlists",
      :headers => {'Authorization' => @auth_token}
      )
    playlists_hash = JSON.parse playlists_json_string

    # playlists_hash['items'] is an array of playlists
    playlists_hash['items'].each do |playlist|
      puts playlist['name']
      if playlist['owner']['id'] == current_user.uid
        tracks_json_string = RestClient::Request.execute(
          :method => :get,
          :url => playlist['tracks']['href'],
          :headers => {'Authorization' => @auth_token}
          )
        tracks_hash = JSON.parse tracks_json_string

        @user = User.find_by(uid: current_user.uid)
        if tracks_hash['items'].empty? == false
          tracks_hash['items'].each do |track|
            @newtrack = Track.new
            @newtrack.id = track['track']['id']
            @newtrack.name = track['track']['name']
            @newtrack.user = @user
            @newtrack.save!
          end
        end
      end
    end

  end

  private

  def track_params
    params.require(:track).permit(:name, :id)
  end

end

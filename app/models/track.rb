class Track < ActiveRecord::Base

  belongs_to :user
  belongs_to :artist

  def self.refresh(credentials, current_user)
    current_user.tracks.destroy_all
    @auth_token = "Bearer #{credentials.token}"
    playlists_json_string = RestClient::Request.execute(
      :method => :get,
      :url => "https://api.spotify.com/v1/users/#{current_user.uid}/playlists",
      :headers => {'Authorization' => @auth_token}
    )
    playlists_hash = JSON.parse playlists_json_string

    # playlists_hash['items'] is an array of playlists
    playlists_hash['items'].each do |playlist|
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
            @newtrack = Track.new(spotify_id: track['track']['id'])
            @newtrack.spotify_id = track['track']['id']
            @newtrack.name = track['track']['name']
            @newtrack.user = @user
            if track['track']['artists'].first['id'] != nil
              @newtrack.artist = Artist.find_or_create_by(
                :spotify_id => track['track']['artists'].first['id'],
                :name => track['track']['artists'].first['name'])
            end
            @newtrack.save!
          end
        end
      end
    end

    current_user.artists.uniq.each do |artist|

      artist_json_string = RestClient.get "https://api.spotify.com/v1/artists/#{artist.spotify_id}"
      artist_hash = JSON.parse artist_json_string
      artist.genres = []
      artist_hash['genres'].each do |genre|
        @genre = Genre.find_or_create_by(:name => genre)
        artist.genres << @genre
      end
    end
  end

end

class Track < ActiveRecord::Base

  belongs_to :user
  belongs_to :artist

  def self.refresh(credentials, current_user)

    returned_ids = []
    new_artists = []
    @user = User.find_by(uid: current_user.uid)
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

        if tracks_hash['items'].empty? == false
          tracks_hash['items'].each do |track|

            returned_ids << track['track']['id']

            @newtrack = Track.find_by(
              spotify_id: track['track']['id'],
              user: @user
            )

            if @newtrack == nil && track['track']['id'] != nil
              @newtrack = Track.new(spotify_id: track['track']['id'])
              @newtrack.spotify_id = track['track']['id']
              @newtrack.name = track['track']['name']
              @newtrack.user = @user

              @newtrack.artist = Artist.find_by(
                :spotify_id => track['track']['artists'].first['id'],
                :name => track['track']['artists'].first['name'])
              if @newtrack.artist == nil
                @newtrack.artist = Artist.new(
                  :spotify_id => track['track']['artists'].first['id'],
                  :name => track['track']['artists'].first['name'])
                new_artists << @newtrack.artist
              end
              @newtrack.save!
            end
          end
        end
      end
    end

    to_delete = @user.tracks.map(&:spotify_id) - returned_ids
    to_delete.each do |track|
      Track.find_by(spotify_id: track).destroy
    end

    Artist.refresh(new_artists)

  end

end

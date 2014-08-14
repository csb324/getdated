class Track < ActiveRecord::Base

  has_and_belongs_to_many :users
  belongs_to :artist

  def self.refresh(credentials, current_user)

    returned_ids = []
    new_artists = []
    all_tracks_info = []
    @user = User.find_by(uid: current_user.uid)
    @auth_token = "Bearer #{credentials.token}"

    # Get the tracks!
    playlists_json_string = RestClient::Request.execute(
      :method => :get,
      :url => "https://api.spotify.com/v1/users/#{current_user.uid}/playlists",
      :headers => {'Authorization' => @auth_token}
    )
    # The return
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

        if !tracks_hash['items'].empty?
          tracks_hash['items'].each do |track|
            returned_ids << track['track']['id']
            all_tracks_info << track['track']
          end
        end
      end
    end

    existing_ids = @user.tracks.map(&:spotify_id)
    # only add's Tracks we don't already have in the database
    Track.where(spotify_id: returned_ids).each do |track|
      if !existing_ids.include?(track.spotify_id)
        @user.tracks << track
      else
        puts "DIDN'T ADD THIS ONE"
      end
    end

    # I want to refresh existing_ids now
    existing_ids = @user.tracks.map(&:spotify_id)
    new_ids = returned_ids.compact - existing_ids

    new_tracks = all_tracks_info.select { |track| new_ids.include?(track['id']) }

    # Add all the new tracks to the database!
    new_tracks.uniq.each do |newtrack|
      @track = Track.new(
        spotify_id: newtrack['id'],
        name: newtrack['name']
      )
      @track.artist = Artist.find_by(
        spotify_id: newtrack['artists'].first['id'],
        name: newtrack['artists'].first['name']
      )
      if @track.artist == nil
        @track.artist = Artist.new(
          spotify_id: newtrack['artists'].first['id'],
          name: newtrack['artists'].first['name']
        )
        new_artists << @track.artist
      end
      @user.tracks << @track
      @track.save!
    end

    to_delete = existing_ids - returned_ids
    to_delete.each do |id|
      @user.tracks.find_by(:spotify_id => id).delete
    end

    Artist.refresh(new_artists)
  end

end

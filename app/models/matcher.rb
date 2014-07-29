class Matcher

  def initialize(user1, user2)
    @user1, @user2 = user1, user2
  end

  def shared_tracks
    user1_track_ids = @user1.tracks.map { |track| track.spotify_id }
    user2_track_ids = @user2.tracks.map { |track| track.spotify_id }
    user1_track_ids & user2_track_ids
  end

  def tracks_count
    shared_tracks.length
  end

  def shared_artists
    @user1.artists & @user2.artists
  end

  def artist_count
    shared_artists.length
  end

  def shared_genres
    @user1.genres & @user2.genres
  end



end



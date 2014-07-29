class Matcher

  def initialize(user1, user2)
    @user1, @user2 = user1, user2
  end

  def shared_tracks
    @user1.tracks.map(&:spotify_id) & @user2.tracks.map(&:spotify_id)
  end

  def tracks_count
    shared_tracks.length
  end

  def shared_artists
    @user1.artists & @user2.artists
  end

  def artists_count
    shared_artists.length
  end

  def artists_by_shared_frequency
    shared_artists_by_freq = Hash.new(0)
    users = [@user1, @user2]
    shared_artists.each do |artist|
      both_freqs = users.map do |user|
        user.artists_with_frequencies[artist]
      end
      shared_artists_by_freq[artist] = both_freqs.min
    end
    # this will turn the hash into an array of 2-element arrays (which we can sort!)
    shared_artists_by_freq.sort_by{ |artist, count| count }.reverse
  end

  def top_shared_artists(limit = 3)
    artists_by_shared_frequency[0...limit]
  end

  def shared_genres
    @user1.genres & @user2.genres
  end

  def genres_by_shared_frequency
    shared_genres_by_freq = Hash.new(0)
    users = [@user1, @user2]
    shared_genres.each do |genre|
      both_freqs = users.map do |user|
        user.genres_with_frequencies[genre]
      end
      shared_genres_by_freq[genre] = both_freqs.min
    end
    # see above!
    shared_genres_by_freq.sort_by{ |genre, count| count }.reverse
  end

  def top_shared_genres(limit = 3)
    genres_by_shared_frequency[0...limit]
  end

end



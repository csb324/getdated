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

  def shared(option)
    if option == :artists
      @user1.artists & @user2.artists
    elsif option == :genres
      @user1.genres & @user2.genres
    else
      puts "please pass in :artists or :genres"
    end
  end

  def shared_count(option)
    shared(option).length
  end

  def shared_by_frequency(option)
    by_freq = Hash.new(0)
    users = [@user1, @user2]
    shared(option).each do |item|
      both_freq = users.map do |user|
        user.frequencies_of(option)[item]
      end
      by_freq[item] = both_freq.min
    end
    by_freq.sort_by{ |item, count| count }.reverse
  end

  def top_shared(option, limit = 3)
    shared_by_frequency(option)[0...limit]
  end

  def score
    track_similarity = tracks_count / (((@user1.tracks.count + @user2.tracks.count) - tracks_count) * 1.0)
    artist_similarity = shared_count(:artists) / (((@user1.artists.uniq.count + @user2.artists.uniq.count) - shared_count(:artists)) * 1.0)
    genre_similarity = shared_count(:genres) / (((@user1.genres.uniq.count + @user2.genres.uniq.count) - shared_count(:genres)) * 1.0)
    (track_similarity * 4) + (artist_similarity * 2) + (genre_similarity * 1)
  end

end



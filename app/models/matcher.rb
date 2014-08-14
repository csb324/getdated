class Matcher

  def initialize(user1, user2)
    @user1, @user2 = user1, user2
  end

  def shared(option)
    if option == :artists
      @user1.artists & @user2.artists
    elsif option == :genres
      @user1.genres & @user2.genres
    elsif option == :tracks
      @user1.tracks & @user2.tracks
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

  def top_shared(option, limit = 5)
    shared_by_frequency(option)[0...limit]
  end

  def calculate_similarity
    raw = 0
    attrs = [[:tracks, 4], [:artist, 2], [:genres, 1]]
    attrs.each do |attr|
      attr_simil = shared_count(attrs[1]) / (((@user1.send([attrs[1].to_s]).uniq.count + @user2.send([attrs[1].to_s]).uniq.count) - shared_count(attrs[1])) * 1.0)
      end
    end
      return raw
  end

  # How users are ranked together
  # Changing the weighting will change Match Score
  # def score
  #   track_similarity = shared_count(:tracks) / (((@user1.tracks.uniq.count + @user2.tracks.uniq.count) - shared_count(:tracks)) * 1.0)
  #   artist_similarity = shared_count(:artists) / (((@user1.artists.uniq.count + @user2.artists.uniq.count) - shared_count(:artists)) * 1.0)
  #   genre_similarity = shared_count(:genres) / (((@user1.genres.uniq.count + @user2.genres.uniq.count) - shared_count(:genres)) * 1.0)

  #   # Maximum possible raw score is seven (with yourself). Most people are between 0 and 1.
  #   raw = (track_similarity * 4) + (artist_similarity * 2) + (genre_similarity * 1)
  #   score = raw * 100
  #   score.round
  # end

  # Shows on the user profiles
  def sample(option, limit = 3)
    if option == :tracks
      names = shared(:tracks).map{ |item| item.name }
      names.shuffle
      names[0...limit]
    else
      names = top_shared(option, (limit + 2)).map { |item| item[0].name }
      names.shuffle[0...limit]
    end
  end

end



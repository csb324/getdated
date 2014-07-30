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

end



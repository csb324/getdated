class Artist < ActiveRecord::Base
  has_many :tracks
  has_and_belongs_to_many :genres

  def self.refresh(current_user)
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

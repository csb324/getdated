class AddATonOfIndexes < ActiveRecord::Migration
  def change
    add_index :artists, :spotify_id
    add_index :artists, :name
    add_index :genres, :name
    add_index :tracks, :artist_id
    add_index :users, :uid
  end
end

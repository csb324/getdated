class CreateJoinArtistsGenres < ActiveRecord::Migration
  def change
    create_join_table :artists, :genres
  end
end

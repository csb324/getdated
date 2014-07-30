class TracksHaveArtists < ActiveRecord::Migration
  def change
    change_table :tracks do |t|
      t.references :artist
    end
  end
end

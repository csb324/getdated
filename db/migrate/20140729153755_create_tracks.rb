class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|
      t.string :spotify_id
      t.string :name
      t.references :user
    end
    add_index :tracks, :spotify_id
  end
end

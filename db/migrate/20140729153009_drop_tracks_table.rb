class DropTracksTable < ActiveRecord::Migration
  def up
    drop_table :tracks
  end
  def down
    create_table :tracks, id: false do |t|
      t.string :id, null: false
      t.references :user
      t.string :name
    end
    add_index :tracks, :id, unique: true
  end
end

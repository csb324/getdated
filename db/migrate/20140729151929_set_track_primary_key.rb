class SetTrackPrimaryKey < ActiveRecord::Migration
  def change
    change_column :tracks, :id, :string, null: false
    add_index :tracks, :id, unique: true
  end
end

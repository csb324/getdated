class ChangeUserTrackRelationship < ActiveRecord::Migration
  def change
    create_join_table :users, :tracks
    remove_column :tracks, :user_id, :integer
  end
end

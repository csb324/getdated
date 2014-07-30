class UpdateFavorites < ActiveRecord::Migration
  def up
    change_table :favorites do |t|
      t.remove :user_1, :user_2
      t.belongs_to :fav_initiator
      t.belongs_to :fav_receiver
    end
  end

  def down
    change_table :favorites do |t|
      t.remove :fav_initiator, :fav_receiver
      t.integer :user_1
      t.integer :user_2
    end
  end
end

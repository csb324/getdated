class CreateFavorites < ActiveRecord::Migration
  def change
    create_table :favorites do |t|
      t.integer :user_1
      t.integer :user_2
      t.boolean :liked_back
      t.timestamps
    end
  end
end

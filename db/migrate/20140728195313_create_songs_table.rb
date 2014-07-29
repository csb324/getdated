class CreateSongsTable < ActiveRecord::Migration
  def change
    create_table :tracks, id: false do |t|
      t.references :user
      t.string :name
      t.string :id
    end
  end
end

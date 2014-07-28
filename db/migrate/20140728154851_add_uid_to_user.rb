class AddUidToUser < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.string :uid, index:true
      t.string :name, index:true
      t.string :provider
    end
  end
end

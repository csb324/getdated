class AddToUsersTable < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.string :age, index:true
      t.string :gender, index:true
      t.string :interested_in, index:true
      t.string :display_name, index:true
      t.string :location, index:true
      t.string :bio
    end
  end
end

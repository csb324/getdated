class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.references :user, index:true
      t.references :favorite, index:true
      t.string :msg
      t.timestamps
    end
  end
end

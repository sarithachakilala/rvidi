class CreateShows < ActiveRecord::Migration
  def up
    create_table :shows do |t|
      t.integer :user_id
      t.string :title
      t.text :description

      t.timestamps    
    end
  end

  def down
    drop_table :shows
  end
end

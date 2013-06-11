class CreateShows < ActiveRecord::Migration
  def up
    create_table :shows do |t|
      t.integer :user_id
      t.string :title
      t.string :show_tag
      t.text :description
      t.string :display_preferences
      t.string :display_preferences_password
      t.string :contributor_preferences
      t.string :contributor_preferences_password
      t.boolean :need_review, :default => true
      t.integer :number_of_views

      t.timestamps    
    end
  end

  def down
    drop_table :shows
  end
end

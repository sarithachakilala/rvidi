class CreateProfileVideos < ActiveRecord::Migration
  def change
    create_table :profile_videos do |t|
      t.integer :user_id
      t.string :thumbnail_url
      t.string :download_url
      t.string :kaltura_entry_id

      t.timestamps
    end
  end
end

class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :title
      t.text :description
      t.integer :cameo_id
      t.string :video_file
      t.string :kaltura_key
      t.datetime :kaltura_syncd_at
      t.string :thumbnail_url
      t.integer :duration

      t.timestamps
    end
  end
end

class AddCameoFile < ActiveRecord::Migration
  def up
    create_table :cameo_files do |t|
      t.integer :cameo_id
      t.string :title
      t.string :start_time
      t.string :end_time
      t.string :video_file
      t.string :audio_file
      t.string :recorded_file
      t.string :download_url
      t.float :duration, :default => 0.0
      t.string :thumbnail_file
      t.integer :number_of_views
      t.string :filename
      t.string :checksum
      t.string :path
      t.integer :filesize
      t.integer :width
      t.integer :height
      t.integer :bit_rate
      t.boolean :success
      t.timestamps
    end
  end

  def down
    drop_table :cameo_files
  end
end

class RemoveColumnsFromCameoFile < ActiveRecord::Migration
  def up
    remove_column :cameo_files, :title
    remove_column :cameo_files, :video_file
    remove_column :cameo_files, :audio_file
    remove_column :cameo_files, :recorded_file
    remove_column :cameo_files, :download_url
    remove_column :cameo_files, :bit_rate
    remove_column :cameo_files, :success
    remove_column :cameo_files, :number_of_views
    remove_column :cameo_files, :filename
    remove_column :cameo_files, :path
    remove_column :cameo_files, :width
    remove_column :cameo_files, :height
    remove_column :cameo_files, :thumbnail_file
    remove_column :cameo_files, :checksum
    remove_column :cameo_files, :end_time
    remove_column :cameo_files, :start_time
  end

  def down
    add_column :cameo_files, :title,           :string
    add_column :cameo_files, :video_file,      :string
    add_column :cameo_files, :audio_file,      :string
    add_column :cameo_files, :recorded_file,   :string
    add_column :cameo_files, :download_url,    :string
    add_column :cameo_files, :bit_rate,        :float
    add_column :cameo_files, :success,         :boolean, :default => true
    add_column :cameo_files, :number_of_views, :integer
    add_column :cameo_files, :filename,        :string
    add_column :cameo_files, :path,            :string
    add_column :cameo_files, :width,           :integer
    add_column :cameo_files, :height,          :integer
    add_column :cameo_files, :thumbnail_file,  :string
    add_column :cameo_files, :checksum,        :string
    add_column :cameo_files, :end_time,        :float
    add_column :cameo_files, :start_time,      :float

  end
end

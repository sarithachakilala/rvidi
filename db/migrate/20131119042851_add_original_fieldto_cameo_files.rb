class AddOriginalFieldtoCameoFiles < ActiveRecord::Migration
  def change
     add_column :cameo_files, :original_file, :boolean
     add_column :cameo_files, :device, :text
  end
end

class AddFieldsToShow < ActiveRecord::Migration
  def change
    add_column :shows, :enable_download, :boolean, :default => false
    add_column :shows, :download_preference, :integer 
  end
end

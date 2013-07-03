class AddDownloadUrlToShows < ActiveRecord::Migration
  def change
    add_column :shows, :download_url, :string
  end
end

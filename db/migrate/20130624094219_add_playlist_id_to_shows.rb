class AddPlaylistIdToShows < ActiveRecord::Migration
  def change
    add_column :shows, :kaltura_playlist_id, :string
  end
end

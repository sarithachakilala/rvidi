class RemoveColumnsFromCameos < ActiveRecord::Migration
  def up
    remove_column :cameos, :start_time
    remove_column :cameos, :end_time
    remove_column :cameos, :download_url
    remove_column :cameos, :duration
    remove_column :cameos, :thumbnail_url
    remove_column :cameos, :kaltura_entry_id
  end

  def down
    add_column :cameos, :kaltura_entry_id, :string
    add_column :cameos, :thumbnail_url, :string
    add_column :cameos, :duration, :float
    add_column :cameos, :download_url, :string
    add_column :cameos, :end_time, :string
    add_column :cameos, :start_time, :string
  end
end

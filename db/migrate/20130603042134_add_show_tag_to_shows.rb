class AddShowTagToShows < ActiveRecord::Migration
  def change
    add_column :shows, :show_tag, :string
  end
end

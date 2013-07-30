class ChangeNumberOfViewsColumnShows < ActiveRecord::Migration
  def up
    change_column :shows, :number_of_views, :integer, :default => 0
  end

  def down
    change_column :shows, :number_of_views, :integer, :default => 0
  end
end

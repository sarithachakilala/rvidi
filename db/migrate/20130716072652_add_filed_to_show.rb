class AddFiledToShow < ActiveRecord::Migration
  def change
    add_column :shows, :cameo_duration, :float, :default => 0.0
  end
end

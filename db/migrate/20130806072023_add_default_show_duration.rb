class AddDefaultShowDuration < ActiveRecord::Migration
  def up
    change_column :shows, :duration, :float, :default => 600.0
  end

  def down
    change_column :shows, :duration, :float, :default => 600.0
  end
end

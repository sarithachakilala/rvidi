class AssignDefaultValuesToShowAndCameoFileds < ActiveRecord::Migration
  def up
    change_column :cameos, :show_order, :integer, :default => 0
    change_column :cameos, :duration, :float, :default => 1.0
    change_column :shows, :cameo_duration, :float, :default => 60.0
  end

  def down
    change_column :cameos, :show_order, :integer, :default => 0
    change_column :cameos, :duration, :float, :default => 1.0
    change_column :shows, :cameo_duration, :float, :default => 60.0
  end
end

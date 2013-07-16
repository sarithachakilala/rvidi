class ChangeCameoDefaultDuration < ActiveRecord::Migration
  def up
    change_column :shows, :cameo_duration, :float, :default => 15.0
  end

  def down
    change_column :shows, :cameo_duration, :float, :default => 10.0
  end
end

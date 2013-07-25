class ChangeShowDefaultTime < ActiveRecord::Migration
  def up
    change_column :shows, :duration, :float, :default => 60.0
  end

  def down
    change_column :shows, :duration, :float, :default => 60.0
  end
end

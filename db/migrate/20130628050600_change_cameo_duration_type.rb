class ChangeCameoDurationType < ActiveRecord::Migration
  def up
    remove_column :cameos, :duration
    add_column :cameos, :duration, :float
  end

  def down
    change_column :cameos, :duration, :string
  end
end

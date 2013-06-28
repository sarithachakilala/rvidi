class AddCameoFieldsToCameos < ActiveRecord::Migration
  def change
    add_column :cameos, :title, :string
    add_column :cameos, :start_time, :string
    add_column :cameos, :end_time, :string
  end
end

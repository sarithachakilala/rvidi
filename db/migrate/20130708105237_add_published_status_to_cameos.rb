class AddPublishedStatusToCameos < ActiveRecord::Migration
  def change
    add_column :cameos, :published_status, :string
  end
end

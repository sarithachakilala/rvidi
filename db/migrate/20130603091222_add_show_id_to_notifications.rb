class AddShowIdToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :show_id, :integer
  end
end

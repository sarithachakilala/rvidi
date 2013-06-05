class AddReadStatusToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :read_status, :boolean, :default =>false
  end
end

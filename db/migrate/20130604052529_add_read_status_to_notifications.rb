class AddReadStatusToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :read_status, :string
  end
end

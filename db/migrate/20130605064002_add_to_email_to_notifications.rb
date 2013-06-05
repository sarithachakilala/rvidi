class AddToEmailToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :to_email, :string
  end
end

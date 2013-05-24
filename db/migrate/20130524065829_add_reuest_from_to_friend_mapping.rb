class AddReuestFromToFriendMapping < ActiveRecord::Migration
  def change
    add_column :friend_mappings, :request_from, :integer
  end
end

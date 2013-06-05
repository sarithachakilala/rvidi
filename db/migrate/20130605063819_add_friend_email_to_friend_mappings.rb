class AddFriendEmailToFriendMappings < ActiveRecord::Migration
  def change
    add_column :friend_mappings, :friend_email, :string
  end
end

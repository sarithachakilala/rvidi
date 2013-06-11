class CreateFriendMappings < ActiveRecord::Migration
  def change
    create_table :friend_mappings do |t|
      t.integer :user_id
      t.integer :friend_id
      t.integer :request_from
      t.string :status
      t.string :friend_email

      t.timestamps
    end
  end
end

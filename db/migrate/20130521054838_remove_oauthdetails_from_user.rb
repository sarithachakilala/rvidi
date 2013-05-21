class RemoveOauthdetailsFromUser < ActiveRecord::Migration
  def up
    remove_column :users, :oauth_token
    remove_column :users, :oauth_expires_at
  end

  def down
    add_column :users, :oauth_expires_at, :datetime
    add_column :users, :oauth_token, :string
  end
end

class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.string :email
      t.string :username
      t.string :password_hash
      t.string :password_salt
      t.string :name
      t.string :provider      
      t.string :uid
      t.string :city
      t.string :state
      t.string :country
      t.integer :profile_video_id
      t.text :description
      t.string :oauth_token
      t.datetime :oauth_expires_at

      t.timestamps    
    end
  end

  def down
    drop_table :users
  end
end

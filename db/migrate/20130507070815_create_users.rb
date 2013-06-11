class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.string :email
      t.string :username
      t.string :password_hash
      t.string :password_salt
      t.string :first_name
      t.string :last_name
      t.string :city
      t.string :state
      t.string :country
      t.integer :profile_video_id
      t.integer :sign_in_count, :default => 0
      t.text :description
      t.string :image
      t.string :password_reset_token
      t.datetime :password_reset_sent_at

      t.timestamps    
    end
  end

  def down
    drop_table :users
  end
end

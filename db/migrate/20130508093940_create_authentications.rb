class CreateAuthentications < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
      t.integer :user_id
      t.string :uid
      t.string :provider
      t.string :oauth_token
      t.string :ouath_token_secret
      t.datetime :oauth_expires_at

      t.timestamps
    end
  end
end

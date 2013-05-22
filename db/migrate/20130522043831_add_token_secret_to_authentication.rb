class AddTokenSecretToAuthentication < ActiveRecord::Migration
  def change
    add_column :authentications, :ouath_token_secret, :string
  end
end

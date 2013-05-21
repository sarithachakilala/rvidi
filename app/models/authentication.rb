class Authentication < ActiveRecord::Base
  belongs_to :user
  attr_accessible :oauth_expires_at, :oauth_token, :provider, :uid, :user_id

  validates :uid, :presence => true,
                  :uniqueness => true
  validates :user_id, :provider, :user_id, :oauth_expires_at, :oauth_token, :presence => true
end

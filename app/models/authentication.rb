class Authentication < ActiveRecord::Base
  belongs_to :user
  attr_accessible :oauth_expires_at, :oauth_token, :provider, :uid, :user_id, :ouath_token_secret

  validates :ouath_token_secret, :presence => true, 
                                 :if => Proc.new { |auth| auth.provider == "twitter" }

  validates :oauth_expires_at, :presence => true,
                               :if => Proc.new { |auth| auth.provider == "facebook" }
  validates :uid, :presence => true,
                  :uniqueness => true
  validates :user_id, :provider, :user_id, :oauth_token, :presence => true
end

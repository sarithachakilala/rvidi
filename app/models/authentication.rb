class Authentication < ActiveRecord::Base
  belongs_to :user

  #Validations
  validates :ouath_token_secret, :presence => true,
                                 :if => Proc.new { |auth| auth.provider == "twitter" }
  validates :oauth_expires_at, :presence => true,
  validates :uid, :presence => true,
                  :uniqueness => true
  validates :user_id, :provider, :user_id, :oauth_token, :presence => true
end

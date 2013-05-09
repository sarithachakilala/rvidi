class User < ActiveRecord::Base
  
  attr_accessor :password, :password_confirmation
  attr_accessible :email, :password, :password_confirmation, :username, :city, :state, :country,
                  :name, :description
    
  before_save :encrypt_password

  has_many :authentications

  # VALIDATIONS
  # validates :username, :presence => true
  # validates :email, :presence => true,
                    # :uniqueness => { :case_sensitive => false }
  # validates :password, :presence => true, :on => :create
  # validates_confirmation_of :password
  
  # CLASS METHODS
  def self.authenticate(login, password)
    user = User.find_by_username(login.downcase) || User.find_by_email(login)
    (user && user.match_password?(password)) ? user : nil
  end
  
  # INSTANCE METHODS
  def match_password?(password)
    self.password_hash == BCrypt::Engine.hash_secret(password, self.password_salt)
  end

  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end

  def self.from_omniauth(auth)
    unless auth.blank?
      where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
        user.provider = auth.provider
        user.uid = auth.uid
        user.name = auth.info.name if auth.info.present?
        if auth.provide == "facebook"
          user = user_facebook_details(auth,user)
        else
          user = user_twitter_details(auth,user)
        end
      end
    end
  end

  def self.user_facebook_details(auth,user)
    user.username = auth.extra.raw_info.username if auth.info.username.present?
    user.email = auth.info.email
    user.description = auth.extra.raw_info.bio if auth.extra.raw_info.bio.present?
    user.city = auth.extra.raw_info.hometown.name if auth.extra.raw_info.hometown.present?
    user.state = auth.extra.raw_info.location.name   if auth.extra.raw_info.location.present?
    user.oauth_token = auth.credentials.token
    user.oauth_expires_at = Time.at(auth.credentials.expires_at)
    user.save!
  end 

  def self.user_twitter_details(auth,user)
    user.username = auth.extra.raw_info.screen_name
    user.description = auth.extra.raw_info.description
    user.city = auth.extra.raw_info.location if auth.extra.raw_info.location.present?
    user.oauth_token = auth.credentials.token
    user.save!
  end
end

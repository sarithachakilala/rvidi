class User < ActiveRecord::Base
  
  attr_accessor :password, :password_confirmation
  attr_accessible :email, :password, :password_confirmation, :username
  
  before_save :encrypt_password

  # VALIDATIONS
  validates :username, :presence => true
  validates :email, :presence => true,
                    :uniqueness => { :case_sensitive => false }
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
        user.name = auth.info.name
        user.username = auth.extra.raw_info.username
        user.email = auth.info.email
        user.oauth_token = auth.credentials.token
        user.oauth_expires_at = Time.at(auth.credentials.expires_at)
        user.save!
       end
    end
  end
end

class User
  include Mongoid::Document
  field :email, type: String
  field :provider, type: String
  field :uid, type: Integer
  field :name, type: String
  field :username, type: String
  field :oauth_token, type: String
  field :oauth_expires_at, type: Date
  field :password_hash, type: String
  field :password_salt, type: String
  
  attr_accessible :email, :password, :password_confirmation
  
  attr_accessor :password
  before_save :encrypt_password

  validates :email, :presence => true,
                    :uniqueness => { :case_sensitive => false }
  validates :password, :presence => true, :on => :create
  validates_confirmation_of :password
  
  def self.authenticate(email, password)
    raise User.auth.inspect
    user = User.where(:email=>email).first
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end
  
  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end

  def self.from_omniauth(auth)
    # raise auth.inspect
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.username = auth.info.username
      user.email = auth.info.email
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.save!
    end
  end
end

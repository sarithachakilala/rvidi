class User < ActiveRecord::Base
  
  attr_accessor :password, :password_confirmation, :terms_conditions

  attr_accessible :email, :password, :password_confirmation, :username, :city, :state, :country,
                  :name, :description, :provider, :uid, :terms_conditions
    
  before_save :encrypt_password

  has_many :authentications

  # VALIDATIONS
  validates :username, :presence => true,
                       :uniqueness => true, :if => Proc.new { |user| user.provider.nil? }

  validates :email, :presence => true, :if => Proc.new { |user| user.provider.nil? }
  validates :email, :format => {:with => /^(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})$/i,
                    :message => 'format is Invalid' },
                    :uniqueness => true,
                    :if => Proc.new { |user| user.email.present? }

  validates :password, :presence => true, 
                       :on => :create, 
                       :if => Proc.new { |user| user.provider.nil?}

  validates :password_confirmation, :presence => true,
                                    :on => :create,
                                    :if => Proc.new { |user| user.provider.nil?}

  validate :check_password_confirmation, :on => :create,
           :if => Proc.new { |user| user.password.present? && user.password_confirmation.present? }

  validates :terms_conditions, :acceptance => true,
                               :on => :create
  
  def check_password_confirmation
    is_valdiated = (self.password.present? && self.password_confirmation.present?) ? (self.password == self.password_confirmation) : true
    self.errors.add(:password, " should match Password Confirmation") unless is_valdiated
    return is_valdiated
  end

  # CLASS METHODS
  def self.authenticate(login, password)
    user = User.find_by_username(login.downcase) || User.find_by_email(login)
    (user && user.match_password?(password)) ? user : nil
  end
  
  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
      user.name = auth.info.name if auth.info.present?
      user = (auth.provider == "facebook") ? user_facebook_details(auth,user) : user_twitter_details(auth,user)
    end
  end

  def self.user_facebook_details(auth,user)
    existing_user = User.find_by_email(auth.info.email)
    if existing_user
      authentication = Authentication.where(:user_id => existing_user.id).first
      authentication_record(auth,existing_user) unless authentication 
    else
      user.username = auth.extra.raw_info.username 
      user.email = auth.info.email
      user.description = auth.extra.raw_info.bio 
      user.city = auth.extra.raw_info.hometown.name if auth.extra.raw_info.hometown.present?
      user.state = auth.extra.raw_info.location.name if auth.extra.raw_info.location.present?
      user.save!
      authentication_record(auth,user) 
    end 
  end 

  def self.user_twitter_details(auth,user)
    existing_user = User.find_by_username(auth.extra.raw_info.screen_name)
    if existing_user
      authentication = Authentication.where(:user_id => existing_user.id).first
      authentication_record(auth,existing_user) unless authentication 
    else
      user.username = auth.extra.raw_info.screen_name
      user.description = auth.extra.raw_info.description
      user.city = auth.extra.raw_info.location 
      user.save!
      authentication_record(auth,user)
    end  
  end  

  def self.authentication_record(auth,user)
    authentication = Authentication.new(:user_id=>user.id, :uid=>auth.uid, :provider=>auth.provider,:oauth_token=>auth.credentials.token )
    authentication.oauth_expires_at = Time.at(auth.credentials.expires_at) if auth.credentials.expires_at.present?
    authentication.save
  end
  

  # INSTANCE METHODS
  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end

  def increment_sign_in_count
    self.update_attribute(:sign_in_count, (self.sign_in_count+1))
  end

  def match_password?(password)
    self.password_hash == BCrypt::Engine.hash_secret(password, self.password_salt)
  end

end

class User
  include Mongoid::Document
  include Mongoid::Timestamps

  # Fields Declararion
  field :email, type: String
  field :password_hash, type: String
  field :password_salt, type: String
  
  attr_accessor :password
  attr_accessible :email, :password, :password_confirmation
  
  before_save :encrypt_password

  # VALIDATIONS
  validates :email, :presence => true,
                    :uniqueness => { :case_sensitive => false }
  validates :password, :presence => true, :on => :create
  validates_confirmation_of :password
  
  # CLASS METHODS
  def self.authenticate(email, password)
    user = User.where(:email=>email).first
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end
  
  # INSTANCE METHODS
  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end
end

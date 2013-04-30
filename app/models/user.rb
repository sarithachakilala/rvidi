class User
  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  attr_accessible :email, :password, :password_confirmation, :remember_me
  field :email,              :type => String, :default => ""
  field :encrypted_password, :type => String, :default => ""
  field :name
	validates_presence_of :name
	validates_uniqueness_of :name, :email, :case_sensitive => false
  validates_presence_of :email
  validates_presence_of :password
end

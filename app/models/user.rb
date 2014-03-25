class User < ActiveRecord::Base

  attr_accessor :password, :password_confirmation, :terms_conditions

  attr_accessible :email, :password, :password_confirmation, :username, :city, :state, :country,
    :description, :uid, :terms_conditions, :first_name, :last_name, :image, :remote_image_url

  #Associations

  has_many :authentications
  has_many :shows, :dependent => :destroy
  has_many :cameos, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  has_many :friend_mappings, :dependent => :destroy

   # VALIDATIONS
  validates :first_name, :last_name, :email, :presence => true
  validates :username, :presence => true,
    :uniqueness => true,
    :if => :provider_does_not_exist?

  validates :email, :format => {:with => /^(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})$/i,
    :message => 'format is Invalid' },
    :uniqueness => true,
    :if => Proc.new { |user| user.email.present? }

  validates :password, :presence => true,:length => {:within => 8..40},
    :on => :create

  validates :password_confirmation, :presence => true,
    :on => :create

  validate :check_password_confirmation, :on => :create,
    :if => Proc.new { |user| user.password.present? && user.password_confirmation.present? }

  validates :terms_conditions, :acceptance => {:accept => '1'}, :on => :create

  #Callbacks

  before_save :encrypt_password

  #Gem Related
  mount_uploader :image, ImageUploader

  # CLASS METHODS
  class << self
    def authenticate(login, password)
      user = User.find_by_username(login.downcase) || User.find_by_email(login)
      (user && user.match_password?(password)) ? user : nil
    end

    # Creating an Authentication Record
    def authentication_record(auth,user)
      authentication = Authentication.new(:user_id=>user.id, :uid=>auth.uid, :provider=>auth.provider,:oauth_token=>auth.credentials.token , :ouath_token_secret => auth.credentials.secret)
      authentication.oauth_expires_at = Time.at(auth.credentials.expires_at) if auth.credentials.expires_at.present?
      authentication.save!
    end

    def from_omniauth(auth)
      user = User.new
      user = (auth.provider == "facebook") ? user_facebook_details(auth,user) : user_twitter_details(auth,user)
    end

    def user_facebook_details(auth,user)
      @fb_access_token = auth['credentials']['token']
      existing_user = User.find_by_email(auth.info.email)
      if existing_user
        authentication = Authentication.where(:user_id => existing_user.id).first
        unless authentication
          authentication_record(auth,existing_user)
          existing_user.update_attribute(:sign_in_count, (existing_user.sign_in_count-1))
        else
          authentication.update_attributes(:oauth_token => auth.credentials.token)
        end
        existing_user
      else
        user.username = auth.extra.raw_info.username
        user.first_name = auth.info.first_name if auth.info.first_name.present?
        user.last_name = auth.info.last_name if auth.info.last_name.present?
        user.email = auth.info.email
        user.description = auth.extra.raw_info.bio
        user.city = auth.extra.raw_info.hometown.name if auth.extra.raw_info.hometown.present?
        user.state = auth.extra.raw_info.location.name if auth.extra.raw_info.location.present?
        user.save(:validate => false)
        authentication_record(auth,user)
        user
      end
    end

    def user_twitter_details(auth,user)
      authentication = Authentication.find_by_uid(auth.uid)
      required_user = authentication.present? ? User.find(authentication.user_id) : nil
      if required_user.nil?
        user.username = auth.extra.raw_info.screen_name
        user.description = auth.extra.raw_info.description
        user.city = auth.extra.raw_info.location
        user.save(:validate => false)
        authentication_record(auth,user)
        user
      else
        required_user
      end
    end

    def fetching_facebook
      @graph = Koala::Facebook::API.new(@fb_access_token)
      profile = @graph.get_object("me")
      @profile_image = @graph.get_picture("me")
      friends = @graph.get_connections("me", "friends?fields=id, name, picture.type(large)")
    end

    def friendmapping_creation(from, friend, stautus)
      friend_requst1 = FriendMapping.new(:user_id =>from, :friend_id=>friend, :status => stautus, :request_from => from)
      friend_requst2 = FriendMapping.new(:user_id =>friend, :friend_id=> from, :status => stautus)
      friend_requst1.save!
      friend_requst2.save!
    end

    def configure_twitter(auth_token, auth_secret)
      Twitter::REST::Client.new do |tw|
        tw.consumer_key = configatron.twitter_consumer_key
        tw.consumer_secret = configatron.twitter_consumer_secret
        tw.access_token = auth_token
        tw.access_token_secret = auth_secret
      end
    end

    def current_user_friends(current_user)
      where("id IN(?)", FriendMapping.where(:user_id => current_user.id, :status =>"accepted").map(&:friend_id) || [-9999])
    end

  end

  # INSTANCE METHODS
  def check_password_confirmation
    is_valdiated = (self.password.present? && self.password_confirmation.present?) ? (self.password == self.password_confirmation) : true
    self.errors.add(:password, " should match Password Confirmation") unless is_valdiated
    return is_valdiated
  end

  def contributed_shows
    Show.joins(:cameos).where("cameos.user_id = ? and shows.user_id != ?", self.id, self.id).select('distinct(shows.*)').order("created_at desc")
  end

  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end

  def friends
    @graph = Koala::Facebook::API.new(@fb_access_token)
    profile = @graph.get_object("me")
    friends = @graph.get_connections("me", "friends")
  end

  def increment_sign_in_count
    self.update_attribute(:sign_in_count, (self.sign_in_count+1))
  end

  def is_director?(show)
    (self.id == show.user_id)
  end

  def full_name
    (first_name.to_s + " " + last_name.to_s).strip.titlecase
  end

  def match_password?(password)
    self.password_hash == BCrypt::Engine.hash_secret(password, self.password_salt)
  end

  def provider_does_not_exist?
    authentications = Authentication.where(:user_id => self.id)
  end

  def send_password_reset
    self.password_reset_token = SecureRandom.urlsafe_base64
    self.password_reset_sent_at = Time.zone.now
    save!
    RvidiMailer.delay.password_reset(self)
  end

  def is_friend?(director)
    FriendMapping.exists?(["user_id = ? AND friend_id = ? ", id, director.id])
  end

end
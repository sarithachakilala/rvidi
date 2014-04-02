class Show < ActiveRecord::Base

  module Download_Preferences
    ME = 1
    FRIENDS = 2
    PUBLIC = 3
  end

  module Display_Preferences
    PASSWORD_PROTECTED = 'password_protected'
    PRIVATE = 'private'
    PUBLIC = 'public'
    NON_FRIEND = 1
    NOT_AUTHENTICATED = 2
  end

  module Contributor_Preferences
    PASSWORD_PROTECTED = 'password_protected'
    PRIVATE = 'private'
    PUBLIC = 'public'
    NON_FRIEND = 1
    NOT_AUTHENTICATED = 2
  end

  after_create :create_permalink

  # Associations
  belongs_to :director, :class_name => "User", :foreign_key => "user_id"
  has_many :cameos, :dependent => :destroy
  #accepts_nested_attributes_for :cameos, :allow_destroy => true

  has_many :comments, :dependent => :destroy
  has_many :notifications, :dependent => :destroy
  has_many :invite_friends, :dependent => :destroy

  # Validations
  validates :user_id, :presence => true
  validates :title, :presence => true
  validates :description, :presence => true
  validates :display_preferences, :presence => true
  validates :contributor_preferences, :presence => true
  validates :display_preferences_password, :presence => true,
    :if => Proc.new {|dpp| dpp.display_preferences == Show::Contributor_Preferences::PASSWORD_PROTECTED }
  validates :contributor_preferences_password, :presence => true, :if => Proc.new {|cpp| cpp.contributor_preferences == "password_protected" }
  # validates :duration, :inclusion => {:in => 60..600 } # In Minutes
  validates :cameo_duration, :inclusion => { :in => 1..60 } # In Seconds


  # Callbacks
  #------

  # Scopes
  scope :public_shows, where(:display_preferences => "public")
  scope :public_private_shows, where('display_preferences LIKE ? OR display_preferences LIKE ?','public', 'private')
  scope :public_protected_shows, where('display_preferences LIKE ? OR display_preferences LIKE ?','public', 'password_protected')
  scope :my_shows, proc {|current_user_id| where(:user_id => current_user_id) }

  # INSTANCE METHODS
  # TODO need a test
  def update_active_cameos(cameos_arr)
    cameos.each do|cameo|
      if cameos_arr.include?(cameo.id.to_s)
        cameo.update_attributes(:status => "enabled")
      else
        cameo.update_attributes(:status => "disabled")
      end
    end
  end

  # TODO use gem friendly id
  def create_permalink
    if self.title
      self.permalink = self.title.to_permalink + "-#{self.id}"
      self.save
    end
  end

  def disable_download
    self.enable_download = false
    self.download_preference = nil
    save
  end

  def steam_download_path
    if Rails.env == 'development'
      File.join(Rails.root, 'tmp', 'downloaded_streams')
    else
      "/var/www/apps/rvidi/shared/streams/downloaded_streams"
    end
  end

  def download_complete_show(client, ks)
    cameo = Cameo.new
    file_paths = []
    timestamp = Time.now.to_i
    cameos.each do |cameo|
      # this is to be moved to CameoFile
      from_file = cameo.download_url
      to_file = "#{steam_download_path}/#{cameo.id}_#{timestamp}.avi"
      CameoFile.wget_download(from_file, to_file)

      input_file = "#{steam_download_path}/#{cameo.id}_#{timestamp}.avi"
      output_file = "#{steam_download_path}/#{cameo.id}_#{timestamp}.mpg"

      CameoFile.avconv_convert_from_avi_to_mpg(input_file, output_file)
      file_paths << output_file

      #File.delete("#{steam_download_path}.avi")  if File.exists?("#{steam_download_path}.avi")
      #File.delete("#{steam_download_path}.mpg")  if File.exists?("#{steam_download_path}.mpg")
    end

    stitched_file = "#{steam_download_path}/show_#{id}_#{timestamp}.mpg"
    CameoFile.concatinate_files_to_single_file(file_paths, stitched_file)
  end

  def current_user_is_a_director?(current_user)
    current_user == director
  end

  def current_user_is_a_friend_of_director?(current_user)
    current_user.present? && current_user.is_friend?(director)
  end

  # Refactoring with test justification
  def set_display_preference(current_user, display_preference)

    # current_user is director OR
    # current_user is a friend of director
    is_director = current_user_is_a_director?(current_user)
    is_friend = current_user_is_a_friend_of_director?(current_user)

    return true if self.display_preferences == Show::Display_Preferences::PUBLIC || is_director
    if self.display_preferences == Show::Display_Preferences::PRIVATE && is_friend
      true
    else
      Show::Display_Preferences::NON_FRIEND
    end

    if self.display_preferences == Show::Display_Preferences::PASSWORD_PROTECTED && display_preference == 'checked'
      true
    else
      Show::Display_Preferences::NOT_AUTHENTICATED
    end
  end

  def first_cameo_thumb( format = :thumb )
    (cameos.first) ? cameos.first.thumbnail_url(format) : Rvidi::Application::IMAGES_DUMMY_FILE
  end

  # Refactoring with test justifiction
  def set_contributor_preference(current_user, contributor_preference)

    # current_user is director OR
    # current_user is a friend of director
    is_director = current_user_is_a_director?(current_user)
    is_friend = current_user_is_a_friend_of_director?(current_user)

    return true if self.contributor_preferences == Show::Contributor_Preferences::PUBLIC || is_director
    if self.contributor_preferences == Show::Contributor_Preferences::PRIVATE && is_friend
      true
    else
      Show::Contributor_Preferences::NON_FRIEND
    end

    if self.contributor_preferences == Show::Contributor_Preferences::PASSWORD_PROTECTED && contributor_preference == 'checked'
      true
    else
      Show::Contributor_Preferences::NOT_AUTHENTICATED
    end
  end

  # Refactoring with test justification
  # it shoueld return only active cameos dration if this conditions
  # it shold return the total duration if this condition
  def get_max_cameo_duration current_user
    if new_record?
      remaining_duration = self.duration * 60
    else
      remaining_duration = 15 #(self.duration) - (self.cameos.map(&:duration).compact.sum)
    end
    return remaining_duration if user_id == current_user.id
    if cameo_duration < remaining_duration
      cameo_duration
    else
      remaining_duration
    end
  end

end



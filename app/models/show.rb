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
  end
  
  attr_accessible :user_id, :title, :description, :display_preferences, :display_preferences_password,
    :contributor_preferences, :contributor_preferences_password, :need_review,
    :cameos_attributes, :show_tag, :end_set, :duration, :enable_download,
    :download_preference, :download_url
    
  after_create :create_permalink
    
  # Validations
  validates :user_id, :presence => true
  validates :title, :presence => true
  validates :description, :presence => true
  validates :display_preferences, :presence => true
  validates :contributor_preferences, :presence => true
  validates :display_preferences_password, :presence => true, :if => Proc.new {|dpp| dpp.display_preferences == "password_protected" }
  validates :contributor_preferences_password, :presence => true, :if => Proc.new {|cpp| cpp.contributor_preferences == "password_protected" }

  # Associations
  belongs_to :director, :class_name => "User", :foreign_key => "user_id"
  has_many :cameos, :dependent => :destroy
  accepts_nested_attributes_for :cameos
  has_many :comments, :dependent => :destroy

  # Callbacks
  #before_create :create_playlist

  # Scope
  scope :public_shows, where(:display_preferences => "public")  
  scope :public_private_shows, where('display_preferences LIKE ? OR display_preferences LIKE ?','public', 'private')  
  scope :public_protected_shows, where('display_preferences LIKE ? OR display_preferences LIKE ?','public', 'password_protected')  


  # CLASS METHODS
  # INSTANCE METHODS
  def update_active_cameos(cameos_arr)
    cameos.each do|cameo|
      if cameos_arr.include?(cameo.id.to_s)
        cameo.update_attributes(:status => "enabled") 
      else
        cameo.update_attributes(:status => "disabled") 
      end unless (cameo.director_id == cameo.user_id)
    end
  end

  def build_playlist
    client = Cameo.get_kaltura_client(user_id)
    playlist = Kaltura::KalturaPlaylist.new
    playlist.name = "#{title}"
    playlist.playlist_type = Kaltura::KalturaPlaylistType::STATIC_LIST
    playlist.type = Kaltura::KalturaEntryType::AUTOMATIC
    playlist.playlist_content = if cameos.present?
      "#{cameos.enabled.order('show_order ASC').map(&:kaltura_entry_id).join(',')}"
    else
      ""
    end
    logger.debug "********"
    logger.debug playlist.playlist_content
    logger.debug "********"
    playlist = client.playlist_service.add(playlist)
    self.kaltura_playlist_id = playlist.id
    self.save
  end
  
  def create_playlist
    if cameos.present? 
      client = Cameo.get_kaltura_client(user_id)
      if kaltura_playlist_id.present?
        playlist = client.playlist_service.get(kaltura_playlist_id)
        client.playlist_service.delete(playlist.id) if playlist.present?
        self.kaltura_playlist_id = nil
        build_playlist
      else
        build_playlist
      end
    end
  end
  
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
  
  def download_complete_show(client, ks)
    cameo = Cameo.new
    val = []
    timestamp = Time.now.to_i
    cameos.each do |each_cameo|
      `wget -O "#{steam_download_path}/#{each_cameo.id}_#{timestamp}.avi" "#{each_cameo.download_url}"` #downloading each cameo
      `avconv -i "#{steam_download_path}/#{each_cameo.id}_#{timestamp}.avi" -qscale:v 1 "#{steam_download_path}/#{each_cameo.id}_#{timestamp}".mpg`   #for processing the input stream
      val << "#{steam_download_path}/#{each_cameo.id}_#{timestamp}.mpg"
      logger.debug "********* #{each_cameo.id} ************"
      #File.delete("#{steam_download_path}.avi")  if File.exists?("#{steam_download_path}.avi")
      #File.delete("#{steam_download_path}.mpg")  if File.exists?("#{steam_download_path}.mpg")
    end
    
    `cat #{val.join(' ')} > "#{steam_download_path}/show_#{id}_#{timestamp}.mpg"`  #concatinating the cameos
    delay.push_stitched_video_to_kaltura(id, timestamp, client, ks, cameo)
  end

  def steam_download_path
    if Rails.env == 'development'
      File.join(Rails.root, 'tmp', 'downloaded_streams')
    else
      "/var/www/apps/rvidi/shared/streams/downloaded_streams"
    end
  end

  def push_stitched_video_to_kaltura(id, timestamp, client, ks, cameo)
    new_file = File.open("#{steam_download_path}/show_#{id}_#{timestamp}.mpg") if File.exists?("#{steam_download_path}/show_#{id}_#{timestamp}.mpg")
    media_entry = cameo.upload_video_to_kaltura(new_file, client, ks)
    cameo.set_uploaded_video_details(media_entry)
    File.delete("#{steam_download_path}/#{id}_#{timestamp}.mpg")
    update_attributes(:download_url =>  media_entry.download_url)
  end

  def download_video?(current_user)
    if end_set.present? && enable_download.present?
      case download_preference
      when Show::Download_Preferences::ME
        director == current_user
      when Show::Download_Preferences::FRIENDS
        current_user.is_friend?(director)
      when Show::Download_Preferences::PUBLIC
        true
      end
    else
      false
    end
  end

  def set_display_preference(current_user, display_preference)

    if current_user == director
      is_director = true
    elsif current_user.present? && current_user.is_friend?(director)
      is_friend = true
    else
      is_friend = false
    end
    
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

end
  

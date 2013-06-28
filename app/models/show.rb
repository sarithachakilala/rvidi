class Show < ActiveRecord::Base

  attr_accessible :user_id, :title, :description, :display_preferences, :display_preferences_password, 
    :contributor_preferences, :contributor_preferences_password, :need_review,
    :cameos_attributes, :show_tag, :end_set, :duration  

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



end

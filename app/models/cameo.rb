class Cameo < ActiveRecord::Base
  attr_accessor :video_file
  attr_accessible :director_id, :show_id, :show_order, :status, :user_id, :name, :description,
                  :thumbnail_url, :download_url, :duration, :video_file

  # Validations
  validates :director_id, :presence => true, :numericality => true
  validates :user_id, :presence => true, :numericality => true
  # validates :show_id, :presence => true, :numericality => true # Need t o be added in after_save, to avoid being added from Terminal.
  validates :status, :presence => true, 
                      :inclusion => { :in => %w(pending approved disabled enabled),
                                      :message => "%{value} is not a valid status" }
  validates :name, :presence => true
  validates :thumbnail_url, :presence => true
  validates :download_url, :presence => true

  # Associations
  belongs_to :show
  belongs_to :user
  belongs_to :director, :class_name => "User", :foreign_key => "director_id"

  # Callbacks

  # METHODS
  # Class Methods

  # Methods to manage Videos using Kaltura Starts
  # KALTURA CONFIGURATION METHODS STARTS
  def self.get_kaltura_config
    kaltura_config = Kaltura::KalturaConfiguration.new(configatron.kaltura_partner_id, configatron.service_url)
    # kaltura_config.format = 1 # for json response (default: 2 - xml response)
    kaltura_config
  end

  def self.get_kaltura_client(user_id)
    kaltura_config = get_kaltura_config    
    kaltura_client = Kaltura::KalturaClient.new( kaltura_config )
    ks = kaltura_client.session_service.start( configatron.administrator_secret, user_id, Kaltura::KalturaSessionType::ADMIN )
    kaltura_client.ks = ks
    kaltura_client
  end
  # KALTURA CONFIGURATION METHODS ENDS

  # KALTURA METHODS TO CALL API METHODS STARTS
  def self.fetch_kaltura_videos(client, ks)
    media_entry_filter = Kaltura::KalturaMediaEntryFilter.new
    filter_pager = Kaltura::KalturaFilterPager.new    
    video_token = client.media_service.list(media_entry_filter, filter_pager, ks)
  end
  # KALTURA METHODS TO CALL API METHODS ENDS

  # =======================================.
  # UNDER TEST DEVELOPMENT.
  # Request for Uploading a video
  def self.upload_video_to_kaltura(video, client, ks)
    media_entry = Kaltura::KalturaMediaEntry.new
    media_entry.name = "test upload video 01"
    media_entry.description = "test upload video 01 description"

    media_entry.media_type = Kaltura::KalturaMediaType::VIDEO

    video_token = client.media_service.upload(video, ks)

    created_entry = client.media_service.add_from_uploaded_file(media_entry, video_token, ks)
    
    media_entry = get_kaltura_video(client, created_entry.id)
    media_entry
  end

  def self.get_kaltura_video(client, kaltura_entry_id)
    media_entry = client.base_entry_service.get(kaltura_entry_id)        
  end

  # Methods to manage Videos using Kaltura Ends
  # INSTANCE METHODS
  def set_uploaded_video_details(media_entry)
    self.status = self.status || "pending"
    self.name =  media_entry.name
    self.description =  media_entry.description
    self.thumbnail_url =  media_entry.thumbnail_url
    self.download_url =  media_entry.download_url
    self.duration =  media_entry.duration
    self.kaltura_entry_id =  media_entry.id
    self.show_order = (latest_cameo_order+1)
  end

  def latest_cameo_order
    Cameo.where('show_id = ?', show_id).order('show_order desc').limit(1).first.try(:show_order) || 0
  end

end

class Video < ActiveRecord::Base
  attr_accessor :thumbnail_url, :duration, :kaltura_key, :kaltura_syncd_at, :video_file, :cameo_id
  attr_accessible :thumbnail_url, :duration, :kaltura_key, :kaltura_syncd_at, :video_file, :cameo_id, :title, :description

  # CLASS METHODS
  # Methods to manage Videos using Kaltura

  # KALTURA CONFIGURATION METHODS STARTS
  def self.get_kaltura_config
    kaltura_config = Kaltura::KalturaConfiguration.new(configatron.kaltura_partner_id, configatron.service_url)
    # kaltura_config.format = 1 # for json response (default: 2 - xml response)
    kaltura_config
  end

  def self.get_kaltura_client
    kaltura_config = get_kaltura_config    
    kaltura_client = Kaltura::KalturaClient.new( kaltura_config )
    ks = kaltura_client.session_service.start( configatron.administrator_secret, configatron.user_id, Kaltura::KalturaSessionType::ADMIN )
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
  def self.upload_video(client, ks)
    media_entry = Kaltura::KalturaMediaEntry.new
    media_entry.name = "test upload video 01"
    media_entry.description = "test upload video 01 description"

    media_entry.media_type = Kaltura::KalturaMediaType::VIDEO
    video_file_1 = File.open("/home/qwinix/Desktop/RF2010WimbleCommer.mp4")
    
    video_token = client.media_service.upload(video_file_1, ks)

    created_entry = client.media_service.add_from_uploaded_file(media_entry, video_token, ks)
    
    media_entry = client.base_entry_service.get(created_entry.id)
  end
end


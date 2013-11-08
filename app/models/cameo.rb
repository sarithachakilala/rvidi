class Cameo < ActiveRecord::Base

  module Status
    Enabled   = 'enabled'
    Pending   = 'pending'
    Disabled  = 'disabled'
  end

  MAX_LENGTH = 60
  STANDARD_LENGTH = 60

  attr_accessor :video_file, :audio_file, :recorded_file, :name_flag, :thumbnail_url_flag,
  
    :download_url_flag
  attr_accessible :director_id, :show_id, :show_order, :status, :user_id, :name, :description, :title, :published_status
  # :start_time,:video_file, :audio_file, :recorded_file, :end_time, :download_url, :duration, :thumbnail_url

  # Associations
  belongs_to :show
  belongs_to :user
  belongs_to :director, :class_name => "User", :foreign_key => "director_id"
  has_one :file, class_name: "CameoFile"

  after_initialize :set_flags

  # Validations
  validates :name, :presence => true
  validates :show_id, :presence => true, :numericality => true
  validates :director_id, :presence => true, :numericality => true
  validates :user_id, :presence => true, :numericality => true
  validates :status, :presence => true,
    :inclusion => { :in => %w(pending disabled enabled),
    :message => "%{value} is not a valid status" }
  validates :name, :presence => true, :if => :name_flag_set?
  #validate :cameo_duration_limit_for_show

  # Callbacks
  after_save :upload_video
  #before_destroy :delete_kaltura_video

  # Scopes
  scope :enabled, where("status like ?", Cameo::Status::Enabled )

  # METHODS

  def upload_video
    temp_file_path = "#{user.id}_#{timestamp}.flv"
    user_directory = "rvidi_user_#{user.id}"
    show_directory = "show_#{show.id}"
    final_file_path = File.join(Rails.root, user_directory, show_directory)
    final_file_name = "#{user.id}_#{show.id}_#{id}.flv"
    temp_file_path = File.join(Rails.root, "tmp")
    temp_file_name = "#{user.id}_#{timestamp}".flv

    `mkdir rvidi_streams/rvidi_user_#{user.id}` unless File.directory?(user_directory).present?
    `mkdir rvidi_streams/rvidi_user_#{user.id}/show_#{show.id}` unless File.directory?(show_directory).present?
   
    `mv #{temp_file_path}/#{temp_file_name} #{final_file_path}/#{final_file_name}`
  end

  def name_flag_set?
    @name_flag == true
  end

  def thumbnail_url_flag_set?
    @thumbnail_url_flag == true
  end

  def download_url_flag_set?
    @download_url_flag == true
  end

  def show_duration_not_excedded?
    (show.duration.to_i) > (show.cameos.map(&:duration).compact.sum + duration.to_i)
  end

  def set_cameo_duration(file)
    self.duration = Cameo.get_video_duration(file)
  end

  def set_fields
    self.status = Cameo::Status::Enabled
    self.published_status = "published"
  end

  def set_flags
    self.name_flag = self.download_url_flag = self.thumbnail_url_flag = false
  end

  def set_fields_and_flags
    set_fields
    set_flags
  end

  # Class Methods
  class << self

    def delete_old_flv_files
      `rm -f #{Rails.root.to_s}/tmp/*.flv`
    end

    def get_video_duration(file)
      file_path = if file.class == ActionDispatch::Http::UploadedFile
        file.tempfile.to_path.to_s
      else
        file.class == File ? (file.path) : (file)
      end
      raw_duration = `ffmpeg -i "#{file_path}" 2>&1 | grep Duration | cut -d ' ' -f 4 | sed s/,//`
      logger.debug "duration is #{raw_duration}"
      raw_duration.split(':')[0].to_i * 3600 + raw_duration.split(':')[1].to_i * 60 + raw_duration.split(':')[2].to_i if raw_duration.present?
    end

    def convert_file_to_flv(current_user, file, cameo_tt)
      if Rails.env == 'development'
        `avconv -i #{file.tempfile.to_path.to_s} -c:v libx264 -ar 22050 -crf 28 -y #{Rails.root.to_s}/tmp/streams/#{current_user.id}_#{cameo_tt}.flv`
        #`ffmpeg -i #{file.tempfile.to_path.to_s} -ar 22050 -y #{Rails.root.to_s}/tmp/streams/#{current_user.id}_#{cameo_tt}.flv`
        #`ffmpeg -i #{file.tempfile.to_path.to_s} -ar 22050 -y #{Rails.root.to_s}/tmp/#{current_user.id}_#{cameo_tt}.flv`
      else
        `avconv -i #{file.tempfile.to_path.to_s} -c:v libx264 -ar 22050 -crf 28 -y "/var/www/apps/rvidi/shared/temp_streams/#{current_user.id}_#{cameo_tt}.flv"`
      end

    end

    def get_flv_file_path(current_user, cameo_tt)
      if Rails.env == 'development'
        File.open("#{Rails.root.to_s}/tmp/streams/#{current_user.id}_#{cameo_tt}.flv")
      else
        File.open("/var/www/apps/rvidi/shared/temp_streams/#{current_user.id}_#{cameo_tt}.flv")
      end
    end

    def delete_uploaded_file(file)
      `rm #{file.tempfile.to_path.to_s}`
    end

    # Methods to manage Videos using Kaltura Starts
    # KALTURA CONFIGURATION METHODS STARTS
    def get_kaltura_config
      kaltura_config = Kaltura::KalturaConfiguration.new(configatron.kaltura_partner_id, configatron.service_url)
      # kaltura_config.format = 1 # for json response (default: 2 - xml response)
      kaltura_config
    end

    def get_kaltura_client(user_id)
      kaltura_config = get_kaltura_config
      kaltura_client = Kaltura::KalturaClient.new( kaltura_config )
      ks = kaltura_client.session_service.start( configatron.administrator_secret, user_id, Kaltura::KalturaSessionType::ADMIN )
      kaltura_client.ks = ks
      kaltura_client
    end
    # KALTURA CONFIGURATION METHODS ENDS

    # KALTURA METHODS TO CALL API METHODS STARTS
    def fetch_kaltura_videos(client, ks)
      media_entry_filter = Kaltura::KalturaMediaEntryFilter.new
      filter_pager = Kaltura::KalturaFilterPager.new
      video_token = client.media_service.list(media_entry_filter, filter_pager, ks)
    end
    # KALTURA METHODS TO CALL API METHODS ENDS
    # Request for Uploading a video

    # To be called from rake task to, Add Videos to kaltura directly Console
    def save_cameo_with_video_in_kaltura(video, client, ks, director_id, user_id)
      cameo = Cameo.new
      cameo.director_id = director_id
      cameo.user = User.find(user_id)
      media_entry = cameo.upload_video_to_kaltura(video, client, ks)
      cameo.set_uploaded_video_details(media_entry)
      saved = cameo.save
      if saved
        p "cameo saved with kaltura entry id: #{cameo.kaltura_entry_id}"
      else
        p "cameo not saved because of errors: #{cameo.errors.messages}"
      end
      cameo
    end

    def get_kaltura_video(client, kaltura_entry_id)
      media_entry = client.base_entry_service.get(kaltura_entry_id)
    end

    def delete_kaltura_video
      client = Cameo.get_kaltura_client(user)
      client.media_service.delete(kaltura_entry_id, client.ks)
    end

    def get_cameo_file current_user, tstamp
      begin
        if Rails.env == 'development'
          File.open(File.join(Rails.root, 'tmp', 'streams',
              get_stream_name(current_user, tstamp) +'.flv'))
        else
          File.open("/var/www/apps/rvidi/shared/streams/#{get_stream_name(current_user, tstamp)}.flv")
        end
      rescue Exception => e
        nil
      end
    end

    def get_stream_name current_user, tstamp
      "#{current_user.id}_#{tstamp}"
    end

    # Interface to modifying the video with ffmpeg
    def clipping_video(cameo, client, ks, start_time, end_time )

      VideoConvert.clip( file , end_time, start_time)

      end_time = end_time.to_i
      start_time = start_time.to_i
      first_temp_file = File.join(Rails.root, 'tmp', "#{cameo.id}.flv")
      second_temp_file = File.join(Rails.root, 'tmp', "#{cameo.id}#{cameo.show_id}.avi")

      donwload = `wget -O "#{first_temp_file}" "#{cameo.download_url}"`
      logger.debug "%%%%%%%%%----#{File.open(first_temp_file).path}"
      stripped_output = `ffmpeg -async 1 -i #{first_temp_file} -ss #{start_time} -t #{end_time} -f avi -b:a 700k -ab 160k -ar 44100 -y #{second_temp_file}`
      logger.debug "*********"
      logger.debug first_temp_file
      logger.debug second_temp_file
      logger.debug "*********"
      # command = "avconv -i #{cameo.id}.mp4 -ss #{start_time} -t #{end_time} -y #{cameo.id}#{cameo.show_id}.mp4"
      new_file = File.open(second_temp_file) if File.exists?(second_temp_file)
      logger.debug "&&&&&&&&&&&&---- #{new_file.path}"
      if new_file.present?
        logger.debug "********"
        logger.debug new_file.path
        logger.debug "********"
        # delete = cameo.delete_kaltura_video
        media_entry = cameo.upload_video_to_kaltura(new_file, client, ks)
        cameo.set_cameo_duration(new_file)
        cameo.set_uploaded_video_details(media_entry)
        File.delete(first_temp_file)
        File.delete(second_temp_file)
      end
    end

  end

  # Methods to manage Videos using Kaltura Ends
  # INSTANCE METHODS
  def delete_kaltura_video
    client = Cameo.get_kaltura_client(self.user_id)
    client.base_entry_service.delete(kaltura_entry_id, client.ks)
  end

  def upload_video_to_kaltura(video, client, ks)
    media_entry = Kaltura::KalturaMediaEntry.new
    media_entry.name = user.present? ? user.full_name.titlecase : "downloading_user"
    media_entry.description = title.present? ? title.capitalize : "complete show"

    media_entry.media_type = Kaltura::KalturaMediaType::VIDEO

    video_token = client.media_service.upload(video, ks)

    created_entry = client.media_service.add_from_uploaded_file(media_entry, video_token, ks)

    media_entry = get_kaltura_video(client, created_entry.id)
    media_entry
  end

  def set_uploaded_video_details(media_entry)
    self.status = self.status || "pending"
    self.name =  media_entry.name
    self.description =  media_entry.description
    self.thumbnail_url =  media_entry.thumbnail_url
    self.download_url =  media_entry.download_url
    self.kaltura_entry_id =  media_entry.id
    self.show_order = (latest_cameo_order+1)
  end

  def get_kaltura_video(client, kaltura_entry_id)
    client.base_entry_service.get(kaltura_entry_id)
  end

  def latest_cameo_order
    Cameo.where('show_id = ?', show_id).order('show_order desc').limit(1).first.try(:show_order) || 0
  end

  def destroy_cameo
    begin
      delete_kaltura_video
      destroy
    rescue
      destroy
    end
  end

  def invite_my_friend_to_this_show?(current_user)
    show.contributor_preferences == Show::Contributor_Preferences::PUBLIC ||
      show.director == current_user
  end

end










class Cameo < ActiveRecord::Base

  module Status
    All = ['enabled', 'pending', 'disabled']
    Enabled   = 'enabled'
    Pending   = 'pending'
    Disabled  = 'disabled'

  end

  MAX_LENGTH = 60
  STANDARD_LENGTH = 60

  attr_accessor :video_file, :audio_file, :recorded_file, :name_flag,
                :thumbnail_url_flag, :download_url_flag

  attr_accessible :director_id, :show_id, :show_order, :status, :user_id, :name,
                  :description, :title, :published_status, :files, :files_attributes




  # Associations
  belongs_to :show
  belongs_to :user
  belongs_to :director, :class_name => "User", :foreign_key => "director_id"

  has_many :files, class_name: "CameoFile", :dependent => :destroy
  accepts_nested_attributes_for :files, :allow_destroy => true,
                                :reject_if => proc {|file| file['file'].blank?}

  after_initialize :set_flags
  before_validation :auto_enable, on: :create

  after_create :move_file_movie_to_server

  # Validations
  validates :show_id,
            :presence => true,
            :numericality => true,
            :if => proc {|cameo| cameo.show_id.present? }

  validates :director_id, :presence => true, :numericality => true
  validates :user_id, :presence => true, :numericality => true
  validates :status, :presence => true,
    :inclusion => { :in => Cameo::Status::All, :message => "%{value} is not a valid status" }
  validates :title, :presence => true


  # Scopes
  Status::All.each do |status|
    scope status.to_sym, where("status like ?", status )
  end
  scope :asc, order( "show_order asc" )

  # METHODS

  def name_flag_set?
    @name_flag == true
  end

  def thumbnail_url_flag_set?
    @thumbnail_url_flag == true
  end

  def download_url_flag_set?
    @download_url_flag == true
  end

  def set_fields
    self.status = Cameo::Status::Enabled
    self.published_status = "published"  # TODO refactor this for getting proper test
  end

  def set_flags
    self.name_flag = self.download_url_flag = self.thumbnail_url_flag = false
  end

  def set_fields_and_flags
    set_fields
    set_flags
  end

  def latest_cameo_order
    Cameo.where('show_id = ?', show_id).order('show_order desc').limit(1).
          first.try(:show_order) || 0
  end

  def invite_my_friend_to_this_show?(current_user)
    show.contributor_preferences == Show::Contributor_Preferences::PUBLIC ||
      show.director == current_user
  end

  def files?
    (files.count > 0)
  end

  def downloable_files?
    files? && files.first.file.present?
  end

  def thumbnail_url( format = :thumb, device_format  = :web  )
    video = get_video_for(device_format)
    ( downloable_files? && video.file.send(format).url) ? video.file.send(format).url : Rvidi::Application::IMAGES_DUMMY_FILE
  end

  def rtmp_streaming_url( format = :web )
    ( downloable_files? ) ? get_video_for(format).media_server.rtmp_streaming_url : "faked"
  end

  def video_format_exists?(format)
    self.files.where( device: format.to_s ).count > 0
  end

  def generate_mp4( format = :web )
    if files.count > 0 && !video_format_exists?(format)
      new_cameo_file = CameoFile.new
      new_file = files.first.get_transcode(format)
      new_cameo_file.file = new_file
      new_cameo_file.device = format.to_s
      files << new_cameo_file
      save!
      File.delete new_file.path
      true
    else
      false
    end

  end

  def get_video_for(format = :web)
    video_format_exists?(format) ? self.files.where( :device => format.to_s ).first : self.files.first
  end

  def duration( format = :web )
    video_format_exists?(format) ? get_video_for(format).duration : 0
  end

  def metadata( format = :web )
    video_format_exists?(format) ? get_video_for(format).metadata : {}
  end

  private

    def auto_enable
      if user_id == director_id || ( show && user_id != director_id && !show.need_review? )
        self.status = Cameo::Status::Enabled
      else
        self.status = Cameo::Status::Pending
      end
    end

    def move_file_movie_to_server
      if files.first.present?
        files.first.media_server.move_to_server
        generate_mp4( :web )
        get_video_for( :web ).media_server.move_to_server
      end
    end


end










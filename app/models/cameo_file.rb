class CameoFile < ActiveRecord::Base

  attr_accessible :file
  
  belongs_to :cameo

  #Gem Related
  mount_uploader :file, VideoFileUploader

  before_destroy :remove_file!

  def set_success(format, opts)
    self.success = true
  end

  def file_movie
    FFMPEG::Movie.new( file.path ) if file.present?
  end

  def get_file_duration
    self.duration ||= file_movie.duration
  end

  def self.get_stream_name current_user, tstamp
    "#{current_user.id}_#{tstamp}"
  end

  def avconv_convert_from_avi_to_mpg(input_file, output_file)
    `avconv -i #{input_file} -qscale:v 1 #{output_file}`
  end
  
  def get_file_size
    self.filesize ||= file_movie.size
  end

  def media_server
    MediaServer.new self
  end

end
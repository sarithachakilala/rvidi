class CameoFile < ActiveRecord::Base

  class MoviewError < Exception::StandardError; end


  attr_accessible :file

  belongs_to :cameo

  #Gem Related
  mount_uploader :file, VideoFileUploader

  before_destroy :remove_file!

  def set_success(format, opts)
    self.success = true
  end

  def file_movie
    if file.present?
      @file_moview_object ||= FFMPEG::Movie.new( file.path )
      raise CameoFile::MoviewError("Unable to read file #{file.path}") if !@file_moview_object.valid?
    end
    @file_moview_object
  end

  def get_file_duration
    self.duration ||= file_movie.duration
  end


  def self.get_stream_name current_user, tstamp
    "#{current_user.id}_#{tstamp}"
  end

  def get_file_metadata
    @metadata ||= {duration: file_movie.duration,
    bitrate: file_movie.bitrate,
    size: file_movie.size,
    video_stream: file_movie.video_stream,
    video_codec: file_movie.video_codec,
    colorspace: file_movie.colorspace,
    resolution: file_movie.resolution,
    width: file_movie.width,
    height: file_movie.height,
    frame_rate: file_movie.frame_rate,
    audio_stream: file_movie.audio_stream,
    audio_codec: file_movie.audio_codec,
    audio_sample_rate: file_movie.audio_sample_rate,
    audio_channels: file_movie.audio_channels}
  end

  def get_file_size
    self.filesize ||= file_movie.size
  end

  def media_server
    @media_server ||= MediaServer.new(self)
  end


end
# encoding: utf-8

class VideoFileUploader < CarrierWave::Uploader::Base
  include CarrierWave::Video
  include CarrierWave::Video::Thumbnailer

  version :thumb do
    process thumbnail: [{format: 'png', quality: 10, size: 192, strip: true, logger: Rails.logger}]
    def full_filename for_file
      png_name for_file, version_name
    end
  end

  def png_name for_file, version_name
    %Q{#{version_name}_#{for_file.chomp(File.extname(for_file))}.png}
  end


  # process encode_video: [:mp4, callbacks: { after_transcode: :set_success } ]

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # Include the Sprockets helpers for Rails 3.1+ asset pipeline compatibility:
  # include Sprockets::Helpers::RailsHelper
  # include Sprockets::Helpers::IsolatedHelper

  # Choose what kind of storage to use for this uploader:
  storage :file

  def store_dir
    primary_folder = Rails.env.test? ?  "spec/uploads/" : "public/uploads/"

    # stores in either "production/..." or "test/..." folders
    "#{Rails.root}/#{primary_folder}videos/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def cache_dir
    primary_folder = Rails.env.test? ?  "spec/uploads/" : "uploads/"
    "#{Rails.root}/#{primary_folder}videos/tmp"
  end




end

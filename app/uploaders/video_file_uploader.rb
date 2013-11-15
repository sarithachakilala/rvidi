# encoding: utf-8

class VideoFileUploader < CarrierWave::Uploader::Base
  include CarrierWave::Video
  include CarrierWave::Video::Thumbnailer


  before :cache, :save_original_filename

  def save_original_filename(file)
    model.original_filename ||= file.original_filename if file.respond_to?(:original_filename)
  end


  def filename
     "#{secure_token(20)}.#{file.extension}" if original_filename.present?
  end

  version :thumb do
    process thumbnail: [
      {format: 'png', quality: 10, size: 142, strip: true, logger: Rails.logger}
    ]
    def full_filename for_file
      %Q{#{version_name}_#{for_file.chomp(File.extname(for_file))}.png}
    end
  end

  version :screen do
    process thumbnail: [
      {format: 'png', quality: 10, size: 789, strip: true, logger: Rails.logger}
    ]
    def full_filename for_file
      %Q{#{version_name}_#{for_file.chomp(File.extname(for_file))}.png}
    end
  end

  version :player do
    process thumbnail: [
      {format: 'png', quality: 10, size: 789, strip: true, logger: Rails.logger}
    ]
    def full_filename for_file
      %Q{#{version_name}_#{for_file.chomp(File.extname(for_file))}.png}
    end
  end


  storage :file

  def store_dir
    primary_folder = Rails.env.test? ?  "spec/uploads/" : "public/uploads/"

    # stores in either "production/..." or "test/..." folders
    "#{Rails.root}/#{primary_folder}videos/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def cache_dir
    primary_folder = Rails.env.test? ?  "spec/uploads/" : "public/uploads/"
    "#{Rails.root}/#{primary_folder}videos/tmp"
  end


  protected

    def secure_token(length=16)
      var = :"@#{mounted_as}_secure_token"
      model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.hex(length/2))
    end



end

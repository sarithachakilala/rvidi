class CameoFile < ActiveRecord::Base

  belongs_to :cameo

  #Gem Related
  mount_uploader :file, VideoFileUploader

  def set_success(format, opts)
    self.success = true
  end

  # Class Methods
  def self.wget_download(input_file, output_file)
    `wget -O #{input_file} #{output_file}`
  end

  def self.get_file_duration(file)
    file_path = if file.class == ActionDispatch::Http::UploadedFile
      file.tempfile.to_path.to_s
    else
      file.class == File ? (file.path) : (file)
    end
    duration = `ffmpeg -i #{file} 2>&1 | grep Duration | cut -d ' ' -f 4 | sed s/,//`
    if duration.present?
      duration.split(':')[0].to_i*3600 + duration.split(':')[1].to_i*60 + duration.split(':')[2].to_i
    else
      0
    end
  end

end
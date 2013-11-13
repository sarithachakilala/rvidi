class CameoFile < ActiveRecord::Base

  belongs_to :cameo

  #Gem Related
  mount_uploader :file, VideoFileUploader

  before_destroy :remove_file!

  def set_success(format, opts)
    self.success = true
  end

  # Class Methods
  def self.wget_download(from_file, to_file)
    `wget -O #{to_file} #{from_file}`
  end

  def self.get_file_duration(file)
    file_path = if file.class == ActionDispatch::Http::UploadedFile
      file.tempfile.to_path.to_s
    else
      file.class == File ? (file.path) : (file)
    end
    duration = `ffmpeg -i #{file_path} 2>&1 | grep Duration | cut -d ' ' -f 4 | sed s/,//`
    if duration.present?
      duration.split(':')[0].to_i*3600 + duration.split(':')[1].to_i*60 + duration.split(':')[2].to_i
    else
      0
    end
  end

  def self.get_stream_name current_user, tstamp
    "#{current_user.id}_#{tstamp}"
  end

  def avconv_convert_from_avi_to_mpg(input_file, output_file)
    `avconv -i #{input_file} -qscale:v 1 #{output_file}`
  end

  def concatinate_files_to_single_file(file_paths, stitched_file)
    `cat #{file_paths.join(' ')} > #{stitched_file}`
  end

 
  
end
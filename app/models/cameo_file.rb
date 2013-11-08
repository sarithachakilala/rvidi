class CameoFile < ActiveRecord::Base

  belongs_to :cameo

  #Gem Related
  mount_uploader :file, VideoFileUploader

  def set_success(format, opts)
    self.success = true
  end


end
require 'net/sftp'

class CameoFile::MediaServer

  attr_accessor :config

  def initialize( cameo_file )
    @cameo_file = cameo_file
    load_confi_yaml
    start_connection if Rails.env.production?
  end

  def load_confi_yaml
    @config = YAML.load_file("#{Rails.root}/config/media_server.yml")["development"] # TODO make a switch to user external servers in case needed
  end

  def start_connection
    @session = Net::SSH.start(@config["host"], @config["username"], keys: @config["ssh_keys"])
    @conn = Net::SFTP::Session.new(@session).connect!
  end

  def set_config( attr_name, attr_value )
    @config[attr_name] = attr_value
  end

  def move_to_server
    if Rails.env.production?
      upload_file
    else
      move_to_local_folder
    end
  end

  def http_streaming_url
    "http://#{@config["host"]}:#{@config["port"]}/#{@config["application"]}/mp4:#{File.basename(@cameo_file.file.path)}/manifest.f4m"
  end

  def rtmp_streaming_url
    "rtmp://#{@config["host"]}:#{@config["port"]}/#{@config["application"]}/#{get_file_extension(@cameo_file.file.path)}:#{File.basename(@cameo_file.file.path)}"
  end


  def move_to_local_folder
    `rsync -avz #{@cameo_file.file.path} #{@config["folder"]}/`
  end

  def path
    "#{@config["folder"]}/#{@cameo_file.file.filename}"
  end

  def destroy_file
    if Rails.env.production?

    else
      `rm -fR #{path}`
    end
  end

  def upload_file
    @conn.upload! @cameo_file.file.path, @config["folder"]
  end

  private
  
  def get_file_extension(file)
    extension = File.extname(file).gsub(".", '')
    extension == 'flv' ? 'flv' : 'mp4'
  end
  # # upload a file to a remote server
  # Net::SCP.upload!("remote.host.com", "username",
  #   "/local/path", "/remote/path",
  #   :password => "password")

  # # download a file from a remote server
  # Net::SCP.download!("remote.host.com", "username",
  #   "/remote/path", "/local/path",
  #   :password => password)

  # # download a file to an in-memory buffer
  # data = Net::SCP::download!("remote.host.com", "username", "/remote/path")

end
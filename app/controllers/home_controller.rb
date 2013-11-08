class HomeController < ApplicationController
  before_filter :require_user, :only => [:video_player]

  def index
    @all_shows = Show.public_shows
    @newest_shows =  Show.public_shows.limit(6).order('created_at desc')
    @most_viewed =  Show.public_shows.order('number_of_views desc')
    @most_commented = Show.public_shows.select("shows.id, count('comments.id') as comm_count").joins(:comments).group("shows.id").order("comm_count desc").all
    respond_to do |format|
      format.html{}
      format.json { render json: user }
    end
  end

  def terms_condition
  end

  def my_file
    begin
      if Rails.env == 'development'
        send_file "#{Rails.root.to_s}/tmp/#{current_user.id}_#{session[:timestamp]}.flv", :type => 'video/x-flv'
      else
        send_file "/var/www/apps/rvidi/shared/temp_streams/#{current_user.id}_#{session[:timestamp]}.flv", :type => 'video/x-flv'
      end
    rescue
      render :nothing => true
    end
  end

  def avc_settings
    config = {
      'connectionstring' => 'rtmp://localhost/hdfvr/_definst_',
      'languagefile' => 'translations/en.xml',
      'qualityurl' => '',
      'maxRecordingTime' => 120,
      "useUserId" => "true",
      'userId' => '',
      'outgoingBuffer' => 60,
      'playbackBuffer' =>  1,
      'autoPlay' => 'false',
      'deleteUnsavedFlv' => 'false',
      'hideSaveButton' => 0,
      "onSaveSuccessURL" => "",
      "snapshotSec" => 5,
      "snapshotEnable" => "true",
      "minRecordTime" => 5,
      "backgroundColor" => 0x990000,
      "menuColor" => 0x333333,
      "radiusCorner" => 4,
      "showFps" => 'true',
      "recordAgain" =>  'true',
      "useUserId" =>  'false',
      "streamPrefix" => "videoStream_",
      "streamName" => "",
      "disableAudio" => 'false',
      "chmodStreams" => "",
      "padding" => 2,
      "countdownTimer" => "false",
      "overlayPath" => "fullStar.png",
      "overlayPosition" => "tr",
      "loopbackMic" => "false",
      "showMenu" => "true",
      "showTimer" => 'true',
      "showSoundBar" => 'true',
      "flipImageHorizontally" => 'false'
    }
    respond_to do |format|
      format.html{ render text: config.to_param  }
    end
  end

  def saved_video

    streamName =  params[:streamName]
    streamDuration = params[:streamDuration]
    userId = params[:userId]
    recorderId = params[:recorderId]

  end

  def save_snapshoot

    photoName = params[:name]
    recorderId = params[:recorderId]
    raise params[:qqfile].inspect

  end

end

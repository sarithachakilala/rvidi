module ApplicationHelper

  def user_root_path
    current_user.present? ? dashboard_user_path(current_user) : root_path
  end
  
  def comment(&block)
		#block the content
	end

  def streaming_server_path
    Rails.env == 'development' ? ("rtmp://localhost/oflaDemo/") : ("rtmp://red5.qwinixtech.com/oflaDemo/")
  end

  def get_show_id(object)
    if object.class == Show
      object.id
    else
      object.show.id
    end
  end

  def twitter_friends_or_existing_friends(friends, twitter_friends)
    if twitter_friends.present?
      render :partial => 'friends/twitter_users', :locals => {:twitter_friends => twitter_friends}
    else
      render :partial => 'friends/rvidi_users', :locals => {:users => friends}
    end
  end

  def custom_path(file)
    file.present? ? ("/assets/streams_temp/VTS_01_0.VOB") : ("/assets/recorder/red5recorder.swf")
  end

  def record_or_preview_video(type, time_stamp)
    if type == 'RECORD'
      render :partial => 'shows/player/video_recorder', :locals => {:time_stamp => time_stamp}
    elsif session[:limit_reached].present?
      content_tag :h2, "Video limit is only 60 seconds"
    else
      render :partial => 'shows/player/video_player'
    end

  end
  
end
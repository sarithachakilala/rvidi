module ApplicationHelper

  def user_root_path
    current_user.present? ? dashboard_user_account_path(current_user) : root_path
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

  def twitter_friends_or_existing_friends(friends, twitter_friends, request)
    
    if twitter_friends.present?
      render :partial => 'friends/twitter_users', :locals => {:twitter_friends => twitter_friends, :request_from=> request}
    else
      render :partial => 'friends/rvidi_users', :locals => {:users => friends}
    end
  end

  def custom_path(file)
    file.present? ? ("/assets/streams_temp/VTS_01_0.VOB") : ("/assets/recorder/red5recorder.swf")
  end

  def record_or_preview_video(type, cameo_max_duration)
    if type == 'RECORD'
      render :partial => 'web/shows/player/video_recorder', :locals => {:time_stamp => session[:timestamp],
        :cameo_max_duration => cameo_max_duration.presence || Cameo::MAX_LENGTH
      }
    elsif session[:limit_reached].present?
      content_tag :h2, "Cameo limit is only #{cameo_max_duration} seconds"
    else
      render :partial => 'web/shows/player/video_player', :locals => {:time_stamp => session[:timestamp],
        :cameo_max_duration => cameo_max_duration.presence || Cameo::MAX_LENGTH
      }
    end

  end

  def custom_error_message_no_margin_no_field_name(resource, field, margin = 0)
    if resource.present? && resource.errors.messages[field].present?
      content_tag :p, "#{resource.errors.messages[field][0]}",
        :class => 'error-message', :style => "margin-left:#{margin}px;"
    else
      ''
    end
  end

  def custom_error_message_no_margin(resource, field)
    if resource.present? && resource.errors.messages[field].present?
      content_tag :p, "#{field.to_s.gsub('_',' ').capitalize} #{resource.errors.messages[field][0]}",
        :class => '', :style => 'color:red'
    else
      ''
    end
  end

  def custom_error_message_no_field_name(resource, field)
    if resource.present? && resource.errors.messages[field].present?
      content_tag :p, "#{resource.errors.messages[field][0]}",
        :class => '', :style => 'color:red'
    else
      ''
    end
  end
  
end
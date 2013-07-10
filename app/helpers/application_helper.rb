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
  
end
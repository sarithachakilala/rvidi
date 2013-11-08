class Video::Providers::Kultura < Video::Provider


  # Get the session on Kultura
  def get_kaltura_session
    begin
      if current_user.present?
        session[:client] ||= Cameo.get_kaltura_client(current_user.id)
        session[:ks] ||= session[:client].ks
        p "user loggedin! session is #{session[:ks]}"
      else
        session[:client] = Cameo.get_kaltura_client(User.first)
        session[:ks] ||= session[:client].ks
      end
    rescue Kaltura::KalturaAPIError => e
      p "Handling Kaltura::KalturaAPIError exception ------- 1"
      p e.message
    end
  end


end
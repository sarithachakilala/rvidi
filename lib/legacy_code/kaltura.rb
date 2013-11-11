# Methods to manage Videos using Kaltura Starts
# KALTURA CONFIGURATION METHODS STARTS
def get_kaltura_config
  kaltura_config = Kaltura::KalturaConfiguration.new(configatron.kaltura_partner_id, configatron.service_url)
  # kaltura_config.format = 1 # for json response (default: 2 - xml response)
  kaltura_config
end

def get_kaltura_client(user_id)
  kaltura_config = get_kaltura_config
  kaltura_client = Kaltura::KalturaClient.new( kaltura_config )
  ks = kaltura_client.session_service.start( configatron.administrator_secret, user_id, Kaltura::KalturaSessionType::ADMIN )
  kaltura_client.ks = ks
  kaltura_client
end
# KALTURA CONFIGURATION METHODS ENDS

# KALTURA METHODS TO CALL API METHODS STARTS
def fetch_kaltura_videos(client, ks)
  media_entry_filter = Kaltura::KalturaMediaEntryFilter.new
  filter_pager = Kaltura::KalturaFilterPager.new
  video_token = client.media_service.list(media_entry_filter, filter_pager, ks)
end
# KALTURA METHODS TO CALL API METHODS ENDS
# Request for Uploading a video

# To be called from rake task to, Add Videos to kaltura directly Console
def save_cameo_with_video_in_kaltura(video, client, ks, director_id, user_id)
  cameo = Cameo.new
  cameo.director_id = director_id
  cameo.user = User.find(user_id)
  media_entry = cameo.upload_video_to_kaltura(video, client, ks)
  cameo.set_uploaded_video_details(media_entry)
  saved = cameo.save
  if saved
    p "cameo saved with kaltura entry id: #{cameo.kaltura_entry_id}"
  else
    p "cameo not saved because of errors: #{cameo.errors.messages}"
  end
  cameo
end

def get_kaltura_video(client, kaltura_entry_id)
  media_entry = client.base_entry_service.get(kaltura_entry_id)
end

def delete_kaltura_video
  client = Cameo.get_kaltura_client(user)
  client.media_service.delete(kaltura_entry_id, client.ks)
end

# Methods to manage Videos using Kaltura Ends
# INSTANCE METHODS
def delete_kaltura_video
  client = Cameo.get_kaltura_client(self.user_id)
  client.base_entry_service.delete(kaltura_entry_id, client.ks)
end

def upload_video_to_kaltura(video, client, ks)
  media_entry = Kaltura::KalturaMediaEntry.new
  media_entry.name = user.present? ? user.full_name.titlecase : "downloading_user"
  media_entry.description = title.present? ? title.capitalize : "complete show"

  media_entry.media_type = Kaltura::KalturaMediaType::VIDEO

  video_token = client.media_service.upload(video, ks)

  created_entry = client.media_service.add_from_uploaded_file(media_entry, video_token, ks)

  media_entry = get_kaltura_video(client, created_entry.id)
  media_entry
end

def set_uploaded_video_details(media_entry)
  self.status = self.status || "pending"
  self.name =  media_entry.name
  self.description =  media_entry.description
  self.thumbnail_url =  media_entry.thumbnail_url
  self.download_url =  media_entry.download_url
  self.kaltura_entry_id =  media_entry.id
  self.show_order = (latest_cameo_order+1)
end

def get_kaltura_video(client, kaltura_entry_id)
  client.base_entry_service.get(kaltura_entry_id)
end

def destroy_cameo
  begin
    delete_kaltura_video
    destroy
  rescue
    destroy
  end
end


 # if params[:cameo][:cameos][:video_file].present?
      #   file = Cameo.get_flv_file_path(current_user, session[:timestamp])
      # else
      #   file = Cameo.get_cameo_file(current_user, session[:timestamp])
      # end

      # @cameo.set_cameo_duration(file)

      # if @cameo.show_duration_not_excedded?
      #   begin
      #     media_entry = @cameo.upload_video_to_kaltura(file, session[:client], session[:ks])
      #     @cameo.set_uploaded_video_details(media_entry)
      #   rescue Exception => e
      #     flash[:alert] = e.message
      #     redirect_to new_cameo_path(:show_id => @cameo.show_id, :director_id => @cameo.director_id)
      #     return
      #   end
      # else
      #   flash[:alert] = "Show duration excedded!!"
      #   redirect_to new_cameo_path(:show_id => @cameo.show_id, :director_id => @cameo.director_id)
      #   return
      # end
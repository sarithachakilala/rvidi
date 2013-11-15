# # Methods to manage Videos using Kaltura Starts
# # KALTURA CONFIGURATION METHODS STARTS
# def get_kaltura_config
#   kaltura_config = Kaltura::KalturaConfiguration.new(configatron.kaltura_partner_id, configatron.service_url)
#   # kaltura_config.format = 1 # for json response (default: 2 - xml response)
#   kaltura_config
# end

# def get_kaltura_client(user_id)
#   kaltura_config = get_kaltura_config
#   kaltura_client = Kaltura::KalturaClient.new( kaltura_config )
#   ks = kaltura_client.session_service.start( configatron.administrator_secret, user_id, Kaltura::KalturaSessionType::ADMIN )
#   kaltura_client.ks = ks
#   kaltura_client
# end
# # KALTURA CONFIGURATION METHODS ENDS

# # KALTURA METHODS TO CALL API METHODS STARTS
# def fetch_kaltura_videos(client, ks)
#   media_entry_filter = Kaltura::KalturaMediaEntryFilter.new
#   filter_pager = Kaltura::KalturaFilterPager.new
#   video_token = client.media_service.list(media_entry_filter, filter_pager, ks)
# end
# # KALTURA METHODS TO CALL API METHODS ENDS
# # Request for Uploading a video

# # To be called from rake task to, Add Videos to kaltura directly Console
# def save_cameo_with_video_in_kaltura(video, client, ks, director_id, user_id)
#   cameo = Cameo.new
#   cameo.director_id = director_id
#   cameo.user = User.find(user_id)
#   media_entry = cameo.upload_video_to_kaltura(video, client, ks)
#   cameo.set_uploaded_video_details(media_entry)
#   saved = cameo.save
#   if saved
#     p "cameo saved with kaltura entry id: #{cameo.kaltura_entry_id}"
#   else
#     p "cameo not saved because of errors: #{cameo.errors.messages}"
#   end
#   cameo
# end

# def get_kaltura_video(client, kaltura_entry_id)
#   media_entry = client.base_entry_service.get(kaltura_entry_id)
# end

# def delete_kaltura_video
#   client = Cameo.get_kaltura_client(user)
#   client.media_service.delete(kaltura_entry_id, client.ks)
# end

# # Methods to manage Videos using Kaltura Ends
# # INSTANCE METHODS
# def delete_kaltura_video
#   client = Cameo.get_kaltura_client(self.user_id)
#   client.base_entry_service.delete(kaltura_entry_id, client.ks)
# end

# def upload_video_to_kaltura(video, client, ks)
#   media_entry = Kaltura::KalturaMediaEntry.new
#   media_entry.name = user.present? ? user.full_name.titlecase : "downloading_user"
#   media_entry.description = title.present? ? title.capitalize : "complete show"

#   media_entry.media_type = Kaltura::KalturaMediaType::VIDEO

#   video_token = client.media_service.upload(video, ks)

#   created_entry = client.media_service.add_from_uploaded_file(media_entry, video_token, ks)

#   media_entry = get_kaltura_video(client, created_entry.id)
#   media_entry
# end

# def set_uploaded_video_details(media_entry)
#   self.status = self.status || "pending"
#   self.name =  media_entry.name
#   self.description =  media_entry.description
#   self.thumbnail_url =  media_entry.thumbnail_url
#   self.download_url =  media_entry.download_url
#   self.kaltura_entry_id =  media_entry.id
#   self.show_order = (latest_cameo_order+1)
# end

# def get_kaltura_video(client, kaltura_entry_id)
#   client.base_entry_service.get(kaltura_entry_id)
# end

# def destroy_cameo
#   begin
#     delete_kaltura_video
#     destroy
#   rescue
#     destroy
#   end
# end


# # if params[:cameo][:cameos][:video_file].present?
# #   file = Cameo.get_flv_file_path(current_user, session[:timestamp])
# # else
# #   file = Cameo.get_cameo_file(current_user, session[:timestamp])
# # end

# # @cameo.set_cameo_duration(file)

# # if @cameo.show_duration_not_excedded?
# #   begin
# #     media_entry = @cameo.upload_video_to_kaltura(file, session[:client], session[:ks])
# #     @cameo.set_uploaded_video_details(media_entry)
# #   rescue Exception => e
# #     flash[:alert] = e.message
# #     redirect_to new_cameo_path(:show_id => @cameo.show_id, :director_id => @cameo.director_id)
# #     return
# #   end
# # else
# #   flash[:alert] = "Show duration excedded!!"
# #   redirect_to new_cameo_path(:show_id => @cameo.show_id, :director_id => @cameo.director_id)
# #   return
# # end


# def delete_old_flv_files
#   `rm -f #{Rails.root.to_s}/tmp/*.flv`
# end

# def get_video_duration(file)
#   file_path = if file.class == ActionDispatch::Http::UploadedFile
#     file.tempfile.to_path.to_s
#   else
#     file.class == File ? (file.path) : (file)
#   end
#   raw_duration = `ffmpeg -i "#{file_path}" 2>&1 | grep Duration | cut -d ' ' -f 4 | sed s/,//`
#   logger.debug "duration is #{raw_duration}"
#   raw_duration.split(':')[0].to_i * 3600 + raw_duration.split(':')[1].to_i * 60 + raw_duration.split(':')[2].to_i if raw_duration.present?
# end

# # Class Methods

# def self.convert_file_to_flv(current_user, file, cameo_tt)
#   if Rails.env == 'development'
#     `avconv -i #{file.tempfile.to_path.to_s} -c:v libx264 -ar 22050 -crf 28 -y #{Rails.root.to_s}/tmp/streams/#{current_user.id}_#{cameo_tt}.flv`
#     #`ffmpeg -i #{file.tempfile.to_path.to_s} -ar 22050 -y #{Rails.root.to_s}/tmp/streams/#{current_user.id}_#{cameo_tt}.flv`
#     #`ffmpeg -i #{file.tempfile.to_path.to_s} -ar 22050 -y #{Rails.root.to_s}/tmp/#{current_user.id}_#{cameo_tt}.flv`
#   else
#     `avconv -i #{file.tempfile.to_path.to_s} -c:v libx264 -ar 22050 -crf 28 -y "/var/www/apps/rvidi/shared/temp_streams/#{current_user.id}_#{cameo_tt}.flv"`
#   end

# end

# def self.get_flv_file_path(current_user, cameo_tt)
#   if Rails.env == 'development'
#     File.open("#{Rails.root.to_s}/tmp/streams/#{current_user.id}_#{cameo_tt}.flv")
#   else
#     File.open("/var/www/apps/rvidi/shared/temp_streams/#{current_user.id}_#{cameo_tt}.flv")
#   end
# end

# def self.delete_uploaded_file(file)
#   `rm #{file.tempfile.to_path.to_s}`
# end

# def self.get_cameo_file current_user, tstamp
#   begin
#     if Rails.env == 'development'
#       File.open(File.join(Rails.root, 'tmp', 'streams',
#           get_stream_name(current_user, tstamp) +'.flv'))
#     else
#       File.open("/var/www/apps/rvidi/shared/streams/#{get_stream_name(current_user, tstamp)}.flv")
#     end
#   rescue Exception => e
#     nil
#   end
# end

# def self.get_stream_name current_user, tstamp
#   "#{current_user.id}_#{tstamp}"
# end

# # Interface to modifying the video with ffmpeg
# def self.clipping_video(cameo, client, ks, start_time, end_time )

#   VideoConvert.clip( file , end_time, start_time)

#   end_time = end_time.to_i
#   start_time = start_time.to_i
#   first_temp_file = File.join(Rails.root, 'tmp', "#{cameo.id}.flv")
#   second_temp_file = File.join(Rails.root, 'tmp', "#{cameo.id}#{cameo.show_id}.avi")

#   donwload = `wget -O "#{first_temp_file}" "#{cameo.download_url}"`
#   logger.debug "%%%%%%%%%----#{File.open(first_temp_file).path}"
#   stripped_output = `ffmpeg -async 1 -i #{first_temp_file} -ss #{start_time} -t #{end_time} -f avi -b:a 700k -ab 160k -ar 44100 -y #{second_temp_file}`
#   logger.debug "*********"
#   logger.debug first_temp_file
#   logger.debug second_temp_file
#   logger.debug "*********"
#   # command = "avconv -i #{cameo.id}.mp4 -ss #{start_time} -t #{end_time} -y #{cameo.id}#{cameo.show_id}.mp4"
#   new_file = File.open(second_temp_file) if File.exists?(second_temp_file)
#   logger.debug "&&&&&&&&&&&&---- #{new_file.path}"
#   if new_file.present?
#     logger.debug "********"
#     logger.debug new_file.path
#     logger.debug "********"
#     # delete = cameo.delete_kaltura_video
#     media_entry = cameo.upload_video_to_kaltura(new_file, client, ks)
#     cameo.set_cameo_duration(new_file)
#     cameo.set_uploaded_video_details(media_entry)
#     File.delete(first_temp_file)
#     File.delete(second_temp_file)
#   end
# end

# def upload_video
#   temp_file_path = "#{user.id}_#{timestamp}.flv"
#   user_directory = "rvidi_user_#{user.id}"
#   show_directory = "show_#{show.id}"
#   final_file_path = File.join(Rails.root, user_directory, show_directory)
#   final_file_name = "#{user.id}_#{show.id}_#{id}.flv"
#   temp_file_path = File.join(Rails.root, "tmp")
#   temp_file_name = "#{user.id}_#{timestamp}".flv

#   `mkdir rvidi_streams/rvidi_user_#{user.id}` unless File.directory?(user_directory).present?
#   `mkdir rvidi_streams/rvidi_user_#{user.id}/show_#{show.id}` unless File.directory?(show_directory).present?

#   `mv #{temp_file_path}/#{temp_file_name} #{final_file_path}/#{final_file_name}`
# end

# def show_duration_not_excedded?
#   (show.duration.to_i) > (show.cameos.map(&:duration).compact.sum + duration.to_i)
# end

# def set_cameo_duration(file)
#   self.duration = CameoFile.get_video_duration(file)
# end


# # REMOVE
# def build_playlist
#   client = Cameo.get_kaltura_client(user_id)
#   playlist = Kaltura::KalturaPlaylist.new
#   playlist.name = "#{title}"
#   playlist.playlist_type = Kaltura::KalturaPlaylistType::STATIC_LIST
#   playlist.type = Kaltura::KalturaEntryType::AUTOMATIC
#   playlist.playlist_content = if cameos.present?
#     "#{cameos.enabled.order('show_order ASC').map(&:kaltura_entry_id).join(',')}"
#   else
#     ""
#   end
#   logger.debug "********"
#   logger.debug playlist.playlist_content
#   logger.debug "********"
#   playlist = client.playlist_service.add(playlist)
#   self.kaltura_playlist_id = playlist.id
#   self.save
# end

# # REMOVE
# def create_playlist
#   if cameos.present?
#     client = Cameo.get_kaltura_client(user_id)
#     if kaltura_playlist_id.present?
#       playlist = client.playlist_service.get(kaltura_playlist_id)
#       client.playlist_service.delete(playlist.id) if playlist.present?
#       self.kaltura_playlist_id = nil
#       build_playlist
#     else
#       build_playlist
#     end
#   end
# end

# # REMOVE
# def steam_download_path
#   if Rails.env == 'development'
#     File.join(Rails.root, 'tmp', 'downloaded_streams')
#   else
#     "/var/www/apps/rvidi/shared/streams/downloaded_streams"
#   end
# end


# # REMOVE
# def push_stitched_video_to_kaltura(id, timestamp, client, ks, cameo)
#   new_file = File.open("#{steam_download_path}/show_#{id}_#{timestamp}.mpg") if File.exists?("#{steam_download_path}/show_#{id}_#{timestamp}.mpg")
#   media_entry = cameo.upload_video_to_kaltura(new_file, client, ks)
#   if media_entry.status.to_i == 1
#     cameo.set_uploaded_video_details(media_entry)
#     # File.delete("#{steam_download_path}/show_#{id}_#{timestamp}.mpg")
#     update_attributes(:download_url =>  media_entry.download_url)
#     return true
#   else
#     return false
#   end
# end

# # Check where is used and justify with a test
# def download_video?(current_user)
#   if end_set.present? && enable_download.present?
#     case download_preference
#     when Show::Download_Preferences::ME
#       director == current_user
#     when Show::Download_Preferences::FRIENDS
#       current_user == director || current_user.is_friend?(director)
#     when Show::Download_Preferences::PUBLIC
#       true
#     end
#   else
#     false
#   end
# end


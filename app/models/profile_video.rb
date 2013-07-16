class ProfileVideo < ActiveRecord::Base

  attr_accessor :video_file, :audio_file, :recorded_file
  attr_accessible :download_url, :kaltura_entry_id, :thumbnail_url, :user_id,
  :video_file, :audio_file, :recorded_file

	def get_kaltura_video(client, kaltura_entry_id)
	  media_entry = client.base_entry_service.get(kaltura_entry_id)
	end

  def upload_profile_video_to_kaltura(video, client, ks)
    media_entry = Kaltura::KalturaMediaEntry.new
    media_entry.name = "User_video"

    media_entry.media_type = Kaltura::KalturaMediaType::VIDEO

    video_token = client.media_service.upload(video, ks)

    created_entry = client.media_service.add_from_uploaded_file(media_entry, video_token, ks)

    media_entry = get_kaltura_video(client, created_entry.id)
    media_entry
  end

end
  
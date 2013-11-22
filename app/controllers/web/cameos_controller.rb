module Web

  class CameosController < Web::BaseController

    before_filter :require_user, :only => [:new, :create, :edit, :update,
      :destroy, :validate_video,
      :video_player]

    before_filter :redirect_to_root_page, :only => [:index]

    def index
      @cameos = Cameo.all

      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @cameos }
      end
    end

    def show
      @cameo = Cameo.find(params[:id])
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @cameo }
      end
    end

    def new
      session[:timestamp] = nil
      session[:timestamp] = Time.now.to_i
      #Cameo.delete_old_flv_files
      @cameo = Cameo.new(:show_id => params[:show_id],
        :director_id => params[:director_id], :user_id => current_user.id)

      @cameo.files.build
      @cameo.timestamp = session[:timestamp]

      @show = Show.find(params[:show_id])
      @show_preference = @show.set_contributor_preference(current_user,
        session[:contribution_preference])

      @contribution_preference = params[:preference].present? ? params[:preference] : @show.contributor_preferences

      ## Get the friends list
      @friend_mappings = FriendMapping.where(:user_id => current_user.id, :status =>"accepted")
      @invited = InviteFriend.where(:director_id=> @show.user_id,
        :show_id=> @show.id, :contributor_id => current_user.id,
        :status => "invited" ) if @current_user

      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @cameo }
      end
    end

    def create
      # To find the contributed users.
      @cameo = Cameo.new( params[:cameo] )
      @cameo.timestamp = session[:timestamp]
      @cameo.published_status = "save_cameo"
      # @cameo.link_cameo_file(current_user, session[:timestamp], params[:cameo_src_type])

      # @invited = InviteFriend.where(:director_id=> @cameo.show.user_id, :show_id=> @cameo.show.id, :contributor_id=>current_user.id, :status =>"invited" ) if @current_user

      respond_to do |format|
        if @cameo.save!
          @show = @cameo.show
          #invite_friend(params[:selected_friends],  @show.id) if params[:selected_friends].present?
          format.html { redirect_to edit_web_cameo_path(@cameo), notice: 'Cameo was successfully Saved, Once you Publish your cameo it will added to the Show.'}
          format.js {}
          format.json { render json: @cameo, status: :created, location: @cameo }
        else
          format.html { render action: "new" }
          format.js {}
          format.json { render json: @cameo.errors, status: :unprocessable_entity }
        end
      end

    end

    def edit
      @cameo = Cameo.find(params[:id])
      #@cameo_duration = CameoFile.get_file_duration("#{@cameo.id}.avi")
      @show = @cameo.show
      if @show.cameos.present?
        #        array_of_cameo_duration = @show.cameos.where(:status => "enabled", :published_status => "published").collect(&:duration)
        #        @sum_duration_of_cameos = array_of_cameo_duration.compact.inject{|sum,x| sum + x }
        @sum_duration_of_cameos = 0
      end
      @remaining_contribution = @show.duration.to_f - @sum_duration_of_cameos.to_f
      File.delete("#{@cameo.id}.avi") if File.exists?("#{@cameo.id}.avi")
    end

    def update
      @cameo = Cameo.find(params[:id])
      @cameo.published_status = "published"

      # TODO move comunications to observer
      # @contributed_users = Cameo.where(:show_id=>@cameo.show_id).collect{|cameo| cameo.user_id if (cameo.user_id != @cameo.director_id) && (cameo.user_id != current_user.id)}.uniq
      # @contributed_users.compact.each do |each_contributer|
      #   notification = Notification.create!(:show_id => @cameo.show_id,
      #     :to_id => each_contributer, :from_id => @cameo.director_id,
      #     :status => "others_contributed", :content =>"They also contributed",
      #     :read_status => false)
      # end

      # TODO move communications to observers
      # if (@cameo.user_id != @cameo.director_id)
      #   #Creating a notification to the director
      #   notification = Notification.create(:show_id=>@cameo.show_id, :from_id=>@cameo.user_id, :to_id => @cameo.director_id, :status => "contributed", :content =>"Added a Cameo", :read_status => false)
      #   notification.save!

      #   #checking whether user is friend or not
      #   @invited = InviteFriend.where(:director_id=> @cameo.show.user_id, :show_id=> @cameo.show.id, :contributor_id=>current_user.id, :status =>"invited" ) if @current_user
      #   friend = FriendMapping.where(:user_id=> @cameo.show.user_id, :friend_id => current_user.id, :status => "accepted" )
      #   pending_request = FriendMapping.where(:user_id=> @cameo.show.user_id, :friend_id => current_user.id, :status => "pending" )
      #   User.friendmapping_creation(@cameo.show.user_id, current_user.id, "accepted")  if @invited.present? && !friend.present?

      #   #updating the pending request
      #   if pending_request.present?
      #     pending_request.first.update_attributes(:status =>"accepted")
      #     pending_request2 = FriendMapping.where(:friend_id=> @cameo.show.user_id, :user_id => current_user.id, :status => "pending" )
      #     pending_request2.first.update_attributes(:status =>"accepted")
      #     notification = Notification.where(:to_id => current_user.id, :from_id => @cameo.show.user_id).first
      #     notification.update_attributes(:status => "accepted", :read_status => true)
      #   end
      # end

      @cameo.attributes = params[:cameo]
      if params[:cameo][:start_time].present? && params[:cameo][:end_time].present?
        # Cameo.clipping_video(@cameo, session[:client], session[:ks], params[:cameo][:start_time], params[:cameo][:end_time] )
      end
      respond_to do |format|
        @show = @cameo.show
        if @cameo.save
          format.html { redirect_to web_show_path(@show),
            :notice => 'Cameo was successfully Published.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @cameo.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      @cameo = Cameo.find(params[:id])
      show = @cameo.show
      @cameo.destroy
      respond_to do |format|
        format.html { redirect_to web_show_path(show)}
        format.js {}
        format.json { head :no_content }
      end
    end

    def check_password
      @show = Show.find(params[:show_id])
      if @show.contributor_preferences_password == params[:password]
        @contribution_prefernce = "checked"
        session[:contribution_preference] = "checked"
        redirect_to new_web_cameo_path(:preference => @contribution_prefernce,
          :show_id => params[:show_id],
          :director_id => @show.user_id)
      else
        redirect_to new_web_cameo_path(:show_id => params[:show_id],
          :director_id => @show.user_id),
          :notice => "Invalid Password: Please enter the correct password! "
      end
    end

    def invite_friend(friends, show_id)
      @show = Show.find(show_id)
      @friend_mappings = FriendMapping.where(:user_id => current_user.id, :status =>"accepted")
      friends.each do |each_friend|
        @user = User.find(each_friend)
        InviteFriend.create(:director_id=> @show.user_id,
          :show_id=> @show.id,
          :contributor_id => @user.id,
          :status =>"invited")
        notification = Notification.new(:show_id => @show.id,
          :from_id => current_user.id,
          :to_id=> @user.id,
          :status => "contribute",
          :content=>" has Requested you to contribute for their Show ")
        notification.save!
      end
    end

    def cameo_clipping
      @cameo =  Cameo.find params[:selected_cameo]
      Cameo.clipping_video(@cameo, session[:client], session[:ks],
        params[:start_time], params[:end_time] )
      @cameo.save
    end

    def validate_video
      session[:limit_reached] = nil
      logger.debug "1"
      if params[:show].present? && params[:show][:cameos_attributes].present? && params[:show][:cameos_attributes]['0'][:video_file].present?
        file = params[:show][:cameos_attributes]['0'][:video_file]
        logger.debug "2"
      elsif params[:cameo].present? && params[:cameo][:file_attributes].present?
        file = params[:cameo][:file_attributes]
        logger.debug "3"
      end

      duration = CameoFile.get_file_duration(file)

      if params[:cameo].present? && params[:cameo][:show_id].present?
        show = Show.find_by_id params[:cameo][:show_id]
        cameo_max_duration = show.get_max_cameo_duration current_user
      else
        show = Show.new(params[:show])
        cameo_max_duration = show.get_max_cameo_duration current_user
      end
      #      if duration <= cameo_max_duration && File.extname(file.original_filename) != ".flv"
      #        Cameo.convert_file_to_flv(current_user, file, session[:timestamp])
      #      else
      #        session[:limit_reached] = true
      #        Cameo.delete_uploaded_file(file)
      #      end
      logger.debug "4"
      session[:cameo_max_duration] = cameo_max_duration
      redirect_to web_video_player_path

    end

    def video_player
      if session[:cameo_max_duration].present?
        @cameo_max_duration = session[:cameo_max_duration]
      else
        if params[:cameo].present? && params[:cameo][:show_id].present?
          show = Show.find_by_id(params[:cameo][:show_id])
          @cameo_max_duration = 2#show.get_max_cameo_duration current_user
        else
          show = current_user.shows.build params[:show]
          @cameo_max_duration = 2 #show.get_max_cameo_duration current_user
        end
      end
      session[:type] = params[:type]
      @type = session[:type]
      session[:type] = session[:cameo_max_duration] = nil
      render :layout => false
    end

  end

end

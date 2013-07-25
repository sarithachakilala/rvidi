class ShowsController < ApplicationController

  before_filter :require_user, :only => [:new, :create, :edit, :update, :destroy]
  before_filter :parse_filters_from_url
  before_filter :redirect_to_root_page, :only => [:index]
  
  def index
    @shows = Show.all

    respond_to do |format|
      format.html 
      format.json { render json: @shows }
    end
  end

  def show
    if params[:id].split("-").size > 1
      @show = Show.find(params[:id].split("-").last)
    else
      @show = Show.find(params[:id])
    end
    begin
      @show.create_playlist
    rescue Kaltura::KalturaAPIError => e
      flash[:notice] = "Kaltura API request timeout. Please try later."
      redirect_to root_url
      return
    end
    @show_preference = @show.set_display_preference(current_user, session[:display_preference])
    
    # to update the duration by getting the video duration from kaltura...
    #    show_cameo = @show.cameos.where(:duration => 0.0)
    #    show_cameo.each do |each_cameo|
    #      new_media_entry = Cameo.get_kaltura_video(session[:client], each_cameo.kaltura_entry_id)
    #      each_cameo.update_attributes(:duration => new_media_entry.duration)
    #    end

    # finding the duration of sum of all cameos
    if @show.cameos.present?
      array_of_cameo_duration = @show.cameos.where(:status => "enabled", :published_status => "published").collect(&:duration)
      @sum_duration_of_cameos = array_of_cameo_duration.compact.inject{|sum,x| sum + x }
      @contribution_percentage = ((@sum_duration_of_cameos || 0.0 ) * 100) / @show.duration
    else
      @contribution_percentage = 0
    end
    # @show.caluculating_percentage_and_duration(@show)

    @display_prefernce = params[:preference].present? ? params[:preference] : @show.display_preferences
    @show.update_attribute(:number_of_views, (@show.number_of_views.to_i+1))
    
    @cameo = Cameo.find(params[:cameo_id]) if params[:cameo_id]
    @show_comments = Comment.get_latest_show_commits(@show.id, 3)
    @all_comments = @show.comments
    @invited = InviteFriend.where(:director_id=> @show.user_id, :show_id=> @show.id, :contributor_id=>current_user.id, :status =>"invited" ) if current_user.present?
    @non_rvidi_user_invitation = InviteFriend.where(:director_id=> @show.user_id, :show_id=> @show.id, :contributor_email=>params[:email] ) if params[:email].present?
    @is_friend = FriendMapping.where(:user_id=> @show.user_id, :friend_id=> current_user.id, :status => "accepted") if current_user.present?
    if params[:to_contribute].present?
      @notification = Notification.where(:show_id=> @show, :to_id=>current_user.id)
      @notification.update_all(:read_status =>true) if @notification
    end
    respond_to do |format|
      format.html 
      format.json { render json: @show }
    end
  end

  ## GET /show/new
  def new

    ## Get a time stamp and store it in hidden field of the form .
    ## This time stamp is used for generating the file name 
    ## This helps the create action to find the exact file uploaded by the user, (doesn't matter if 2 or more users are recording concurrently.)
    session[:timestamp] = nil
    session[:timestamp] = Time.now.to_i
    Cameo.delete_old_flv_files
    ## Get the object.
    @show = current_user.shows.build(:display_preferences => "private", :contributor_preferences => "private")
    
    ## Buidling the cameo
    @cameo = @show.cameos.build
    
    ## Get the friend list
    @friend_mappings = FriendMapping.where(:user_id => current_user.id, :status =>"accepted")
    
    respond_to do |format|
      format.html
      format.json { render json: @show }
    end
  end

  def create
    @show = Show.new(params[:show])
    @cameo = @show.cameos.first
    @cameo.set_fields_and_flags
    if @cameo.video_file.present?
      file = Cameo.get_flv_file_path(current_user, session[:timestamp])
    else
      file= Cameo.get_cameo_file(current_user, session[:timestamp])
    end
    @show.duration = @show.duration * 60
    if @show.save
      if file.present?
        cameo_duration = Cameo.get_video_duration(file)
        if cameo_duration < @show.duration
          begin
            media_entry = @cameo.upload_video_to_kaltura(file, session[:client], session[:ks])
            @cameo.set_uploaded_video_details(media_entry)
            @cameo.set_cameo_duration(file)
            @cameo.save
          rescue Exception => e
            @show.destroy
            flash[:alert] = e.message
            redirect_to new_show_path
            return
          end
        else
          @show.destroy
          flash[:alert] = "Maximum show limit is reached!!"
          redirect_to new_show_path
          return
        end
      end
      @success = true
    else
      #show error message
      @success = false
    end

    respond_to do |format|
      if @success
        invite_friend(params[:selected_friends]) if params[:selected_friends].present?
        invite_friend_toshow_after_create(params[:email], @show) if params[:email].present?
        format.html { redirect_to @show, notice: 'Show was successfully created. The system will take few minutes to convert the video. Please check back after few minutes.' }
        format.js {}
        format.json { render json: @show, status: :created, location: @show }
      else
        p "%"*80; p "errors while saving show ------------ : #{@show.errors}"
        format.html { render 'new'}
        format.js {}
        format.json { render json: @show.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @show = Show.find(params[:id])
    @friends = User.current_user_friends(current_user)
    @friend_mappings = FriendMapping.where(:user_id => current_user.id, :status =>"accepted")
    # finding the duration of sum of all cameos
    # @show.caluculating_percentage_and_duration(@show)
    if @show.cameos.present?
      array_of_cameo_duration = @show.cameos.where(:status => "enabled").collect(&:duration)
      @sum_duration_of_cameos = array_of_cameo_duration.compact.inject{|sum,x| sum + x }
      @contribution_percentage = ((@sum_duration_of_cameos || 0.0 ) * 100) / @show.duration
    else
      @contribution_percentage = 0
    end
   
    if session[:uid].present?
      uid = session[:uid]
      User.configure_twitter(session[:auth_token], session[:auth_secret])
      session[:uid] = session[:auth_token] = session[:auth_secret] = nil
      @twitter_friends = Twitter.followers(uid)
    else
      @twitter_friends = []
    end
  end

  def update
    @show = Show.find(params[:id])
    invite_friend(params[:selected_friends]) if params[:selected_friends].present?
    params[:order_list].split(',').each do |each_cameo_by_order|
      cameo  = Cameo.find each_cameo_by_order
      cameo.update_attributes(:show_order => params[:order_list].index(each_cameo_by_order))
    end
    params[:show][:duration] = params[:show][:duration].to_i*60
    respond_to do |format|
      if @show.update_attributes(params[:show])
        @show.disable_download if params[:show][:enable_download].blank?
        params[:active_cameos].present? ? @show.update_active_cameos(params[:active_cameos]) : @show.cameos.update_all(:status => "disabled")
        #@show.create_playlist if @show.cameos.present? && @show.cameos.enabled.present?
        format.html { redirect_to @show, notice: 'Show was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @show.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @show = Show.find(params[:id])
    @show.destroy

    respond_to do |format|
      format.html { redirect_to shows_url }
      format.json { head :no_content }
    end
  end

  # To View the cameo Invitation of a Show
  def view_invitation
    # @show = Show.find(params[:id])
  end

  def play_cameo
    @show = Show.find(params[:id])
    @cameo = @show.cameos.find(params[:cameo_id])
    respond_to do |format|
      format.html { redirect_to show_url(@cameo.show_id, :cameo_id => @cameo.id) }
      format.js {}
      format.json { head :no_content }
    end
  end

  def friends_list
    @users = User.where("username like ?  OR first_name like ? OR last_name like ? OR email like ? ",'%'+params[:search_val]+'%','%'+params[:search_val]+'%','%'+params[:search_val]+'%','%'+params[:search_val]+'%') if params[:search_val].present?
  end

  # Collect all the friends and Invite friends to contribute to the show if checked users or present
  def invite_friend(friends)
    @friend_mappings = FriendMapping.where(:user_id => current_user.id, :status =>"accepted")
    friends.each do |each_friend|
      @user = User.find(each_friend)
      InviteFriend.create(:director_id=> @show.user_id, :show_id=> @show.id, :contributor_id=>@user.id, :status =>"invited" )
      notification = Notification.new(:show_id => @show.id, :from_id=>current_user.id, :to_id=> @user.id, :status => "contribute", :content=>" has Requested you to contribute for their Show ")
      notification.save!
    end
  end

  # Inviting friend via an email while creating a show
  def invite_friend_toshow_after_create(email, show)
    @user = User.find(current_user.id)
    RvidiMailer.delay.invite_friend_to_show(email, current_user, show.id)
    InviteFriend.create(:director_id => show.user_id, :show_id => show.id,
      :contributor_email => email, :status =>"invited" )
    
    flash[:notice] = "Your invitation will be sent as soon as you publish the show"
    notification = Notification.new(:show_id => show.id, :from_id => current_user.id,
      :to_id => '', :status => "contribute",
      :content =>" has Requested you to contribute for their Show ", :to_email=>params[:email])
    notification.save!
  end

  # To invite friend via an email to contribute to show
  def invite_friend_toshow
    @show = Show.find(params[:show_id])
    @user = User.find(params[:email_from])
    RvidiMailer.invite_friend_to_show(params[:email], @user, @show.id).deliver
    InviteFriend.create(:director_id=> @show.user_id, :show_id=> @show.id, :contributor_email=>params[:email], :status =>"invited" )
    notification = Notification.new(:show_id => @show.id, :from_id=>current_user.id, :to_id=> '', :status => "contribute", :content=>" has Requested you to contribute for their Show ", :to_email=>params[:email])
    notification.save!
    redirect_to edit_show_path(:id=>@show.id), :notice => "Invitatiion sent successfully"
  end

  def check_password
    if params[:show_id].split("-").size > 1
      @show = Show.find(params[:show_id].split("-").last)
    else
      @show = Show.find(params[:show_id])
    end
    if @show.display_preferences_password == params[:password]
      @display_prefernce = "checked"
      session[:display_preference] = "checked"
      redirect_to show_path(:id => @show.permalink, :preference => @display_prefernce)
    else
      redirect_to show_path(:id => @show.permalink), :notice => "Invalid Password: Please enter the correct password! "
    end
  end
  
  def status_update
     if params[:show_id].split("-").size > 1
      @show = Show.find(params[:show_id].split("-").last)
    else
      @show = Show.find(params[:show_id])
    end
    end_set_val = params[:status] == "end" ? Time.now : ""
    @show.update_attributes(:end_set => end_set_val)
    if params[:status] == "end"
      @show.download_complete_show(session[:client], session[:ks])
      redirect_to edit_show_path(@show.id), :notice => "Successfully Show got #{params[:status]}ed."
    else
      redirect_to show_path(:id=>@show.id), :notice => "Successfully Show got #{params[:status]}ed."
    end
  end


end

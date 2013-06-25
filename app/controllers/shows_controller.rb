class ShowsController < ApplicationController
  before_filter :require_user, :only => [:new, :create, :edit, :update, :destroy]
  def index
    @shows = Show.all

    respond_to do |format|
      format.html 
      format.json { render json: @shows }
    end
  end

  def show
    @show = Show.find(params[:id])
    @display_prefernce = params[:preference].present? ? params[:preference] : @show.display_preferences 
    @show.update_attribute(:number_of_views, (@show.number_of_views.to_i+1))
    @cameo = Cameo.find(params[:cameo_id]) if params[:cameo_id]
    @show_comments = Comment.get_latest_show_commits(@show.id, 3)
    @all_comments = @show.comments
    @invited = InviteFriend.where(:director_id=> @show.user_id, :show_id=> @show.id, :contributor_id=>current_user.id, :status =>"invited" ) if @current_user
    if params[:to_contribute].present?
      @notification = Notification.where(:show_id=> @show, :to_id=>current_user.id)
      @notification.update_all(:read_status =>true) if @notification
      # commenting because users cant be friends and this code is missing friend id
      # friends = FriendMapping.where(:user_id => current_user.id, :friend_id => @show.user_id, :status => 'accepted')
      # friends ||= FriendMapping.where(:user_id => @show.user_id, :friend_id => current_user.id, :status => 'accepted')
      # User.friendmapping_creation(current_user.id, @show.user_id, "accepted") unless friends.present?
    end
    respond_to do |format|
      format.html 
      format.json { render json: @show }
    end
  end

  def new
    @show = Show.new(:display_preferences => "private", :contributor_preferences => "private")
    @cameo = @show.cameos.build
    @friend_mappings = FriendMapping.where(:user_id => current_user.id, :status =>"accepted")
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @show }
    end
  end

  def edit
    @show = Show.find(params[:id])
    @friend_mappings = FriendMapping.where(:user_id => current_user.id, :status =>"accepted")
  end

  def create
    @show = Show.new(params[:show])
    @cameo = @show.cameos.first    
    if @cameo.video_file.present?
      media_entry = Cameo.upload_video_to_kaltura(@cameo.video_file, session[:client], session[:ks])
      @cameo.set_uploaded_video_details(media_entry)
    else
      begin
        sleep(4);
        stream_file = Cameo.get_cameo_file(@cameo, current_user)
        media_entry = Cameo.upload_video_to_kaltura(stream_file,
          session[:client], session[:ks])
        @cameo.set_uploaded_video_details(media_entry)
      rescue
        @show.cameos = []
      end
    end
    
    @success = @show.save
    @show.create_playlist if @show.cameos.present? && @show.cameos.enabled.present?
    
    respond_to do |format|
      if @success
        invite_friend(params[:selected_friends]) if params[:selected_friends].present?
        format.html { redirect_to @show, notice: 'Show was successfully created.' }
        format.js {}
        format.json { render json: @show, status: :created, location: @show }
      else
        p "%"*80; p "errors while saving show ------------ : #{@show.errors}"
        format.html { redirect_to new_show_path, :notice => @show.errors.full_messages.to_sentence}
        format.js {}
        format.json { render json: @show.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @show = Show.find(params[:id])
    invite_friend(params[:selected_friends]) if params[:selected_friends].present?
    params[:order_list].split(',').each do |each_cameo_by_order|
      camoe  = Cameo.find each_cameo_by_order
      camoe.update_attributes(:show_order => params[:order_list].index(each_cameo_by_order))
    end
    respond_to do |format|
      if @show.update_attributes(params[:show])
        @show.update_active_cameos(params[:active_cameos]) if params[:active_cameos].present?
        @show.create_playlist if @show.cameos.present? && @show.cameos.enabled.present?
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
    @cameo = Cameo.find(params[:cameo_id])    
    
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

  # To invite friend via an email to contribute to show
  def invite_friend_toshow
    @show = Show.find(params[:show_id])
    @user = User.find(params[:email_from])
    RvidiMailer.delay.invite_friend_toshow(params[:email], @user, @show.id)
    InviteFriend.create(:director_id=> @show.user_id, :show_id=> @show.id, :contributor_id=>@user.id, :status =>"invited" )
    notification = Notification.new(:show_id => @show.id, :from_id=>current_user.id, :to_id=> '', :status => "contribute", :content=>" has Requested you to contribute for their Show ", :to_email=>params[:email])
    notification.save!
    redirect_to edit_show_path(:id=>@show.id)
  end

  def check_password
    @show = Show.find(params[:show_id])
    if @show.display_preferences_password == params[:password]
      @display_prefernce = "checked"
      redirect_to show_path(:id=>@show.id, :preference => @display_prefernce)
    else
      redirect_to show_path(:id=>@show.id), :notice => "Invalid Password: Please enter the correct password! "
    end
  end
  
  def status_update
    @show = Show.find(params[:show_id])
    end_set_val = params[:status] == "end" ? Time.now : ""
    @show.update_attributes(:end_set => end_set_val) 
    redirect_to edit_show_path(:id=>@show.id), :notice => "Successfully Show got #{params[:status]}ed."
  end

  def add_twitter_invities
    params[:id] = 4
    @show = Show.find(params[:id])
    if session[:uid].present?
      uid = session[:uid]
      User.configure_twitter(session[:auth_token], session[:auth_secret])
      session[:uid] = session[:auth_token] = session[:auth_secret] = nil
      begin
        @twitter_friends = Twitter.followers(uid.to_i)
        # @twitter_friends|| = [1,2,3]
        redirect_to edit_show_path(params[:id])
      rescue
        @twitter_friends = [1,2,3]
        redirect_to edit_show_path(params[:id])

        flash[:alert] = 'Twitter rake limit exceeded'
        # redirect_to add_twitter_invities_shows_path
        # redirect_to root_url
      end
      
    else
      @twitter_friends = []
    end
  end
end

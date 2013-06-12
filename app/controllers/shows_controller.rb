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
    @show.update_attribute(:number_of_views, (@show.number_of_views.to_i+1))
    @cameo = Cameo.find(params[:cameo_id]) if params[:cameo_id]
    @show_comments = Comment.get_latest_show_commits(@show.id, 3)
    @all_comments = @show.comments
    if params[:to_contribute].present?
      @notification = Notification.where(:show_id=> @show, :to_id=>current_user.id)
      @notification.update_all(:read_status =>true) if @notification
      friends = FriendMapping.where(:user_id => current_user.id, :friend_id => @show.user_id, :status => 'accepted')
      User.friendmapping_creation(current_user.id, @show.user_id, "accepted") unless friends.present?
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
    elsif @cameo.recorded_file.present?
      media_entry = Cameo.upload_video_to_kaltura(@cameo.recorded_file, session[:client], session[:ks])
      @cameo.set_uploaded_video_details(media_entry)
    else
      @show.cameos=[]
    end
    @success = @show.save

    respond_to do |format|
      if @success
        format.html { redirect_to @show, notice: 'Show was successfully created.' }
        format.js {}
        format.json { render json: @show, status: :created, location: @show }
      else
        p "%"*80; p "errors while saving show ------------ : #{@show.errors}"
        format.html { render action: "new" }
        format.js {}
        format.json { render json: @show.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @show = Show.find(params[:id])

    respond_to do |format|
      if @show.update_attributes(params[:show])
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

  def invite_friend
    @show = Show.find(params[:page_id])
    @friend_mappings = FriendMapping.where(:user_id => current_user.id, :status =>"accepted")
    @checkd_users = params[:checked_friends]
    if @checkd_users.present?
      @checkd_users.each do |each_friend|
        @user = User.find(each_friend) 
        notification = Notification.new(:show_id => @show.id, :from_id=>current_user.id, :to_id=> @user.id, :status => "contribute", :content=>"is Requested to contribute for a Show")
        notification.save!
      end
    end
  end

  # To invite friend via an email to contribute to show
  def invite_friend_toshow
    @show = Show.find(params[:show_id])
    @user = User.find(params[:email_from])
    RvidiMailer.delay.invite_friend_toshow(params[:email], @user, @show.id)
    notification = Notification.new(:show_id => @show.id, :from_id=>current_user.id, :to_id=> '', :status => "contribute", :content=>"is Requested to contribute for a Show", :to_email=>params[:email])
    notification.save!
    redirect_to edit_show_path(:id=>@show.id)
  end

end

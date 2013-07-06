class CameosController < ApplicationController
  before_filter :require_user, :only => [:new, :create, :edit, :update, :destroy]

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
    @tstamp = Time.now.to_i
    @cameo = Cameo.new(:show_id => params[:show_id], :director_id => params[:director_id])
    @show = Show.find(params[:show_id])
    @show_preference = @show.set_contributor_preference(current_user, session[:contribution_preference])

    @contribution_preference = params[:preference].present? ? params[:preference] : @show.contributor_preferences 
    
    ## Get the friend list
    @friend_mappings = FriendMapping.where(:user_id => current_user.id, :status =>"accepted")
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @cameo }
    end
  end

  def edit
    @cameo = Cameo.find(params[:id])
  end

  def create
    # To find the contributed users. 
    @cameo = Cameo.new(params[:cameo])
    @contributed_users = Cameo.where(:show_id=>@cameo.show_id).collect{|cameo| cameo.user_id if (cameo.user_id != @cameo.director_id) && (cameo.user_id != current_user.id)}.uniq
    @contributed_users.compact.each do |each_contributer|
      notification = Notification.create!(:show_id => @cameo.show_id,
        :to_id => each_contributer, :from_id => @cameo.director_id,
        :status => "others_contributed", :content =>"They also contributed",
        :read_status => false)
    end 

    if params[:cameo][:cameos][:video_file].present?
      #@cameo.video_file = File.open(params[:cameo][:cameos][:video_file])
      media_entry = @cameo.upload_video_to_kaltura(params[:cameo][:cameos][:video_file], session[:client],
        session[:ks])
      @cameo.set_uploaded_video_details(media_entry)
    else
      begin
        sleep(4);
        stream_file = Cameo.get_cameo_file(current_user, params[:tstamp])
        media_entry = @cameo.upload_video_to_kaltura(stream_file,
          session[:client], session[:ks])
        @cameo.set_uploaded_video_details(media_entry)
      rescue Exception => e
        logger.debug "**********"
        logger.debug e.message
        logger.debug "**********"
        flash[:notice] = "No stream to publish!!"
        redirect_to root_url
        return
      end
    end
    if @cameo.user_id == @cameo.director_id
      @cameo.status = Cameo::Status::Enabled
    else
      @cameo.status = (@cameo.show.need_review == true) ? Cameo::Status::Pending : Cameo::Status::Enabled
    end
    
    @success = @cameo.save

    #Creating a notification to the director
    notification = Notification.create(:show_id=>params[:cameo]['show_id'], :from_id=>params[:cameo]['user_id'], :to_id => params[:cameo]['director_id'], :status => "contributed", :content =>"Added a Cameo", :read_status => false) 
    notification.save!

    respond_to do |format|
      if @success
        @show = @cameo.show
        invite_friend(params[:selected_friends],  @show.id) if params[:selected_friends].present?
        format.html { redirect_to edit_cameo_path(@cameo), notice: 'Cameo was successfully Added.'} 
        format.js {}
        format.json { render json: @cameo, status: :created, location: @cameo }
      else
        format.html { render action: "new" }
        format.js {}       
        format.json { render json: @cameo.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @cameo = Cameo.find(params[:id])
    
    if params[:cameo][:start_time].present? && params[:cameo][:end_time].present?
      @sucess = Cameo.clipping_video(@cameo, session[:client], session[:ks], params[:cameo][:start_time], params[:cameo][:end_time] )
    end 
    respond_to do |format|
      @show = @cameo.show
      if @cameo.update_attributes(params[:cameo])
        format.html { redirect_to @show, notice: 'Cameo was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @cameo.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @cameo = Cameo.find(params[:id])
    @cameo.destroy_cameo
    respond_to do |format|
      format.html { redirect_to cameos_url }
      format.js {}
      format.json { head :no_content }
    end
  end

  def check_password
    @show = Show.find(params[:show_id])
    if @show.contributor_preferences_password == params[:password]
      # @contribution_prefernce = "checked"
      session[:contribution_preference] = "checked"
      redirect_to new_cameo_path(:preference => @contribution_prefernce, :show_id => params[:show_id], :director_id => @show.user_id)
    else
      redirect_to new_cameo_path(:show_id => params[:show_id], :director_id => @show.user_id), :notice => "Invalid Password: Please enter the correct password! "
    end
  end

  def invite_friend(friends, show_id)
    @show = Show.find(show_id)
    @friend_mappings = FriendMapping.where(:user_id => current_user.id, :status =>"accepted")
    friends.each do |each_friend|
      @user = User.find(each_friend) 
      InviteFriend.create(:director_id=> @show.user_id, :show_id=> @show.id, :contributor_id=>@user.id, :status =>"invited" )
      notification = Notification.new(:show_id => @show.id, :from_id=>current_user.id, :to_id=> @user.id, :status => "contribute", :content=>" has Requested you to contribute for their Show ")
      notification.save!
    end
  end

end

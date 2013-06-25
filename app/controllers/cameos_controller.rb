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
    @cameo = Cameo.new(:show_id => params[:show_id], :director_id => params[:director_id])
    @show = Show.find(params[:show_id])
    @contribution_prefernce = params[:preference].present? ? params[:preference] : @show.contributor_preferences 
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
    @contributed_users.each do |each_contributer|
      notification = Notification.create(:show_id=>@cameo.show_id, :to_id=> each_contributer, :from_id => @cameo.director_id, :status => "others_contributed", :content =>"They also contributed", :read_status =>false)
    end

    if params[:cameo][:video_file].present?
      media_entry = Cameo.upload_video_to_kaltura(@cameo.video_file, session[:client],
        session[:ks])
      @cameo.set_uploaded_video_details(media_entry)
    else
      begin
        sleep(4);
        stream_file = Cameo.get_cameo_file(@cameo, current_user)
        media_entry = Cameo.upload_video_to_kaltura(stream_file,
          session[:client], session[:ks])
        @cameo.set_uploaded_video_details(media_entry)
      rescue 
        flash[:notice] = "No stream to publish!!"
        redirect_to root_url
        return
      end
    end
    if @cameo.user_id == @cameo.director_id
      @cameo.status = "enabled"
    else
      @cameo.status = (@cameo.show.need_review == true) ? "pending" : "enabled"
    end

    @success = @cameo.save
    #Creating a notification to the director
    notification = Notification.create(:show_id=>params[:cameo]['show_id'], :from_id=>params[:cameo]['user_id'], :to_id => params[:cameo]['director_id'], :status => "contributed", :content =>"Added a Cameo", :read_status => false) 
    notification.save!

    respond_to do |format|
      if @success
        @show = @cameo.show
        invite_friend(params[:selected_friends]) if params[:selected_friends].present?
        format.html { redirect_to @show, notice: 'Cameo was successfully Added.' }        
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

    respond_to do |format|
      if @cameo.update_attributes(params[:cameo])
        format.html { redirect_to @cameo, notice: 'Cameo was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @cameo.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @cameo = Cameo.find(params[:id])
    kaltura_entry_id = @cameo.kaltura_entry_id
    @success = @cameo.destroy
    Cameo.delete_kaltura_video(kaltura_entry_id, session[:client], session[:ks]) if @success

    respond_to do |format|
      format.html { redirect_to cameos_url }
      format.js {}
      format.json { head :no_content }
    end
  end

  def check_password
    @show = Show.find(params[:show_id])
    if @show.contributor_preferences_password == params[:password]
      @contribution_prefernce = "checked"
      redirect_to new_cameo_path(:preference => @contribution_prefernce, :show_id => params[:show_id], :director_id => @show.user_id)
    else
      redirect_to new_cameo_path(:show_id => params[:show_id], :director_id => @show.user_id), :notice => "Invalid Password: Please enter the correct password! "
    end
  end

  def invite_friend(friends)
    @show = Show.find(params[:show_id])
    @friend_mappings = FriendMapping.where(:user_id => current_user.id, :status =>"accepted")
    friends.each do |each_friend|
      @user = User.find(each_friend) 
      InviteFriend.create(:director_id=> @show.user_id, :show_id=> @show.id, :contributor_id=>@user.id, :status =>"invited" )
      notification = Notification.new(:show_id => @show.id, :from_id=>current_user.id, :to_id=> @user.id, :status => "contribute", :content=>" has Requested you to contribute for their Show ")
      notification.save!
    end
  end

end

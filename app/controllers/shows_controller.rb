class ShowsController < ApplicationController
  before_filter :require_user, :only => [:new, :create, :edit, :update, :destroy]

  # GET /shows
  # GET /shows.json
  def index
    @shows = Show.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @shows }
    end
  end

  # GET /shows/1
  # GET /shows/1.json
  def show
    @show = Show.find(params[:id])
    @cameo = Cameo.find(params[:cameo_id]) if params[:cameo_id]
    @show_comments = Comment.get_latest_show_commits(@show.id, 3)
    @all_comments = @show.comments

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @show }
    end
  end

  # GET /shows/new
  # GET /shows/new.json
  def new
    @show = Show.new(:display_preferences => "private", :contributor_preferences => "private")
    @cameo = @show.cameos.build
    @friend_mappings = FriendMapping.where(:user_id => current_user.id, :status =>"accepted")
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @show }
    end
  end

  # GET /shows/1/edit
  def edit
    @show = Show.find(params[:id])
    @friend_mappings = FriendMapping.where(:user_id => current_user.id, :status =>"accepted")
  end

  # POST /shows
  # POST /shows.json
  def create
    @show = Show.new(params[:show])
    @cameo = @show.cameos.first    
    if @cameo.video_file.present?
      media_entry = Cameo.upload_video_to_kaltura(@cameo.video_file, session[:client], session[:ks])
      @cameo.set_uploaded_video_details(media_entry)
    else
      @show.cameos=[]
    end

    respond_to do |format|
      if @show.save
        format.html { redirect_to @show, notice: 'Show was successfully created.' }
        format.json { render json: @show, status: :created, location: @show }
      else
        p "%"*80; p "errors while saving show ------------ : #{@show.errors}"
        format.html { render action: "new" }
        format.json { render json: @show.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /shows/1
  # PUT /shows/1.json
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

  # DELETE /shows/1
  # DELETE /shows/1.json
  def destroy
    @show = Show.find(params[:id])
    @show.destroy

    respond_to do |format|
      format.html { redirect_to shows_url }
      format.json { head :no_content }
    end
  end

  # To View the cameo Invitation of a Shwo
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
    @users = User.where("username like ? OR email like ?",'%'+params[:search_val]+'%','%'+params[:search_val]+'%') if params[:search_val].present?
  end

  def invite_friend
    params[:checked_friends].each do |each_friend|
      @user = User.find(each_friend) 
      notification = Notification.new(:from_id=>current_user.id, :to_id=> @user.id, :status => "contribute", :content=>"Requested to contribute for a cameo")
      notification.save!
    end
    redirect_to edit_show_path(:id => current_user.id, :notice => "Invitation sent Successfully!" )
  end

end

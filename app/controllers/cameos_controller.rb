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

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @cameo }
    end
  end

  def edit
    @cameo = Cameo.find(params[:id])
  end

  def create
    # To find the contributed user. 
    @contributed_users = Cameo.where(:show_id=>params[:cameo]['show_id']).collect(&:user_id)
    @contributed_users.each do |each_contributer|
      user= User.find(each_contributer)
      notification = Notification.create(:show_id=>params[:cameo]['show_id'], :to_id=>user.id, :from_id => params[:cameo]['director_id'], :status => "others_contributed", :content =>"They also contributed", :read_status =>false)  unless (user.id == params[:cameo]['director_id'])
      notification.save!
    end
    @cameo = Cameo.new(params[:cameo])
    media_entry = Cameo.upload_video_to_kaltura(@cameo.video_file, session[:client], session[:ks])
    @cameo.set_uploaded_video_details(media_entry)

    #Creating a notification to the director
    notification = Notification.create(:show_id=>params[:cameo]['show_id'], :to_id=>params[:cameo]['user_id'], :from_id => params[:cameo]['director_id'], :status => "contributed", :content =>"Added a Cameo", :read_status => false) 
    notification.save!

    respond_to do |format|
      if @cameo.save
        @show = @cameo.show
        format.html { redirect_to @show, notice: 'Cameo was successfully Added.' }        
        format.json { render json: @cameo, status: :created, location: @cameo }
      else
        format.html { render action: "new" }
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
    @cameo.destroy

    respond_to do |format|
      format.html { redirect_to cameos_url }
      format.json { head :no_content }
    end
  end
end

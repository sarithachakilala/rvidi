class CameosController < ApplicationController
  before_filter :require_user, :only => [:new, :create, :edit, :update, :destroy]

  # GET /cameos
  # GET /cameos.json
  def index
    @cameos = Cameo.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @cameos }
    end
  end

  # GET /cameos/1
  # GET /cameos/1.json
  def show
    @cameo = Cameo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @cameo }
    end
  end

  # GET /cameos/new
  # GET /cameos/new.json
  def new
    @cameo = Cameo.new(:show_id => params[:show_id], :director_id => params[:director_id])

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @cameo }
    end
  end

  # GET /cameos/1/edit
  def edit
    @cameo = Cameo.find(params[:id])
  end

  # POST /cameos
  # POST /cameos.json
  def create
    # To find the contributed user. still need to verify
    # @contributed_users = Cameo.where(:show_id=>params[:cameo]['show_id']).collect(&:user_id)
    # @contributed_users.each do |each_contributer|
    #   user= User.find(each_contributer)
    #   notification = Notification.create(:show_id=>params[:cameo]['show_id'], :to_id=>user.id, :from_id => params[:cameo]['director_id'], :status => "others_contributed", :content =>"They also contributed", :read_status =>"unread")  unless (user.id == params[:cameo]['director_id'])
    #   notification.save!
    # end
    @cameo = Cameo.new(params[:cameo])
    media_entry = Cameo.upload_video_to_kaltura(@cameo.video_file, session[:client], session[:ks])
    @cameo.set_uploaded_video_details(media_entry)
    if params[:from].present?
      @notification = Notification.where(:show_id=> params[:cameo]['show_id'], :to_id=>params[:cameo]['user_id'], :from_id => params[:cameo]['director_id']).first
      @notification.update_attributes(:status => "contributed", :read_status =>"unread") if @notification
    else
      notification = Notification.create(:show_id=>params[:cameo]['show_id'], :to_id=>params[:cameo]['user_id'], :from_id => params[:cameo]['director_id'], :status => "contributed", :content =>"Added a Cameo", :read_status =>"unread") 
      notification.save!
    end

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

  # PUT /cameos/1
  # PUT /cameos/1.json
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

  # DELETE /cameos/1
  # DELETE /cameos/1.json
  def destroy
    @cameo = Cameo.find(params[:id])
    @cameo.destroy

    respond_to do |format|
      format.html { redirect_to cameos_url }
      format.json { head :no_content }
    end
  end
end

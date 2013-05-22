class CameosController < ApplicationController
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
    @cameo = Cameo.new(params[:cameo])
    media_entry = Cameo.upload_video_to_kaltura(@cameo.video_file, session[:client], session[:ks])
    @cameo.set_uploaded_video_details(media_entry)

    respond_to do |format|
      if @cameo.save
        p "1"*80;
        format.html { redirect_to @cameo, notice: 'Cameo was successfully created.' }
        format.json { render json: @cameo, status: :created, location: @cameo }
      else
        p "*"*80; p @cameo.errors
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

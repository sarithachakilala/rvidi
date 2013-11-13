require 'spec_helper'

describe CameoFile do


   it "should create a valid factory" do
    cameo_file = FactoryGirl.build :cameo_file
    cameo_file.should be_valid
  end

  describe "upload file" do

    before :all do
      @cameo_file = FactoryGirl.build :cameo_file
    end

    it "should storage the file in given storage directory and remove it when cameo_file is deleted" do
      @cameo_file.file = File.open("spec/fixtures/videos/sample.mp4")
      @cameo_file.save!
      path = @cameo_file.file.path
      File.exists?(path).should be_true
      expect{
        @cameo_file.destroy
      }.to change(CameoFile, :count).by(-1)
      File.exists?(path).should be_false
    end
  end


  describe "working with video file" do

    before :all do
      @cameo_file = FactoryGirl.build :cameo_file
      @cameo_file.file = File.open("spec/fixtures/videos/sample.mp4")
      @cameo_file.save!
    end

    after :all do
      @cameo_file.destroy
    end

    it "should return an FFMPEG::Movie object to work with video" do
      @cameo_file.file_movie.should be_instance_of(FFMPEG::Movie)
    end

    it "should return duration and cache in db" do
      @cameo_file.get_file_duration.should be 596.46 #Fixed number given fixed movie in fixtures
      @cameo_file.save
      @cameo_file.reload
      @cameo_file.duration.to_f.should be 596.46
    end

    it "should return file size and cache it in db" do
      @cameo_file.get_file_size.should be 39115156 #Fixed number given fixed movie in fixtures
      @cameo_file.save
      @cameo_file.reload
      @cameo_file.filesize.to_i.should be 39115156
    end

    it "should have a media server object" do
      @cameo_file.media_server.should be_instance_of(CameoFile::MediaServer)
    end

  end

end

require 'spec_helper'

describe CameoFile::MediaServer do

  before :all do
    @cameo_file = FactoryGirl.build :cameo_file
    @cameo_file.file = File.open("spec/fixtures/videos/sample.flv")
    @cameo_file.save!
  end

  after :all do
    @cameo_file.destroy
  end

  describe "working with media server" do


    it "should have a config folder and host" do
      @cameo_file.media_server.config["host"].should be_instance_of(String)
      @cameo_file.media_server.config["folder"].should be_instance_of(String)
    end

    it "should move the file to media server and delete it" do
      @cameo_file.media_server.move_to_server
      path = @cameo_file.media_server.path
      File.exists?(path).should be_true
      path.should eq("#{@cameo_file.media_server.config["folder"]}/#{@cameo_file.file.filename}")
      @cameo_file.media_server.destroy_file
      File.exists?(path).should be_false
    end


    describe "Errors" do

      it "should rise an Error if connection is not possible" do
        expect{
          @cameo_file.media_server.set_config "host", "albuquerque"
          @cameo_file.media_server.start_connection
        }.to raise_exception
      end

    end

  end

end

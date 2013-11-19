require 'spec_helper'

describe Cameo do

  before(:all) do
    CameoFile.destroy_all
    Cameo.destroy_all
  end

  it{ should validate_presence_of(:user_id)  }
  it{ should validate_presence_of(:director_id)  }
  Cameo::Status::All.each do |allowed|
    it{ should allow_value(allowed).for(:status)   }
  end
  it{ should validate_presence_of(:title)  }

  it "should create a valid factory" do
    cameo = FactoryGirl.build :cameo
    cameo.should be_valid
  end



  describe "Creation callbacks" do
    before :all do
      @show = FactoryGirl.build :show
      @cameo = FactoryGirl.build :cameo, :show => @show
    end

    it { should callback(:auto_enable).before(:validation) }

    it "should be enabled if user is director" do
      @cameo.user_id, @cameo.director_id = [23,23]
      @cameo.send :auto_enable
      @cameo.status.should be Cameo::Status::Enabled
    end

    it "should not be enabled if user is not director and show needs review " do
      @cameo.user_id, @cameo.director_id = [23,25]
      @show.stub!(:need_review?).and_return(true)
      @cameo.send :auto_enable
      @cameo.status.should be Cameo::Status::Pending
    end

    it "should be enable if user is not director and show doesn't need review " do
      @cameo.user_id, @cameo.director_id = [23,25]
      @show.stub!(:need_review?).and_return(false)
      @cameo.send :auto_enable
      @cameo.status.should be Cameo::Status::Enabled
    end

  end

  describe "Thumbnails" do
    before :all do
      @cameo = FactoryGirl.build :cameo
      @cameo.stub!(:file).and_return(nil)
    end
    it "should return a placeholder image from the system if file have no thumbnail" do
      @cameo.thumbnail_url.should match /\/assets\/dummy.jpeg/
    end
  end

  describe "transcoding to mp4" do

    before :all do
      @cameo_file = FactoryGirl.build :cameo_file
      @cameo_file.file = File.open("spec/fixtures/videos/sample.flv")
      @cameo_file.save!
      @cameo = @cameo_file.cameo
    end

    after :all do
      @cameo.destroy
    end

    it "should transcode any input format to mp4 if not mp4 format is given" do
      expect{
        @cameo.generate_mp4( :web )
      }.to change(CameoFile, :count).by(1)
      @cameo.reload
      @cameo.files.size.should eq(2)
      @cameo.files[0].filename.should_not eq(@cameo.files[1].filename)
      @cameo.files[1].metadata["video_codec"] = "h264"
    end

    it "not generate more than 1 movie to each device" do
      @cameo.files.where( "id != #{@cameo.files.first.id}" ).destroy_all

      expect{
        @cameo.generate_mp4( :web )
      }.to change(CameoFile, :count).by(1)

      expect{
        @cameo.generate_mp4( :web )
      }.to change(CameoFile, :count).by(0)
    end

    it "should return original video if video for device doesn't exists" do
      @cameo.get_video_for(:web).should eq( @cameo.files.first )
    end

    it "should return a proper transcoded profile given a device " do
      expect{
        @cameo.generate_mp4( :web )
      }.to change(CameoFile, :count).by(1)
      @cameo.reload
      @cameo.get_video_for(:web).should eq( @cameo.files[1] )
    end

  end


end

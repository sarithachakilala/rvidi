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

end

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
  it{ should validate_presence_of(:show_id)  }
  it{ should validate_presence_of(:title)  }

  it "should create a valid factory" do
    expect{
      cameo = FactoryGirl.create :cameo
    }.to change(Cameo, :count).by(1)
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


end

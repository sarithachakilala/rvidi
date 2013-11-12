require 'spec_helper'

describe Cameo do

  before(:all) do
    CameoFile.destroy_all
    Cameo.destroy_all
  end

  it{ should validate_presence_of(:user_id)  }
  it{ should validate_presence_of(:director_id)  }
  it{ should validate_presence_of(:status)  }
  it{ should validate_presence_of(:show_id)  }
  it{ should validate_presence_of(:name)  }

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

    it "should call the enabling callback on create" do
      @cameo.should_receive :auto_enable
      @cameo.run_callbacks(:save) { false }
    end

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

  # expecting it to have a __FILE__

  #   file: if is an upload
  #   should be doing this

  #   if is a record show be doind this


  #   If media server is hosted by if __FILE__ == $PROGRAM_NAME
  #     should move the file to media server
  #     get and URl
  #   end

  #   if media server is external provider
  #     should move the file to external provider and get and ID and url
end

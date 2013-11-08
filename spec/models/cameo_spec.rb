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

require 'spec_helper'

describe User do
  before(:all) do
    User.destroy_all
  end

  it{ should validate_presence_of(:first_name)  }
  it{ should validate_presence_of(:username)  }
  it{ should validate_presence_of(:email)  }
  it{ should validate_presence_of(:password)  }
  it{ should validate_acceptance_of(:terms_conditions)  }

  it "factory should create a valid object" do
    expect{
      cameo = FactoryGirl.create :user
    }.to change(User, :count).by(1)
  end


end

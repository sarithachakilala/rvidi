require 'spec_helper'

describe Show do
  pending "add some examples to (or delete) #{__FILE__}"

  before(:all) do    
  end

  before(:each) do
    Show.destroy_all
    @new_show = Show.new
    @show = create(:show)
  end

  it{ should validate_presence_of(:user_id)  }
  it{ should validate_presence_of(:title)  }
  it{ should validate_presence_of(:description)  }
  it{ should belong_to(:user) }

  context "Instance Methods" do
  end

end

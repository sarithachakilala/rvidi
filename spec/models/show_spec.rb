require 'spec_helper'

describe Show do
  # pending "add some examples to (or delete) #{__FILE__}"

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
  it{ should validate_presence_of(:display_preferences)  }
  it{ should validate_presence_of(:contributor_preferences)  }
  it{ should belong_to(:director) }
  it{ should have_many(:cameos) }

  context "Class Methods" do
  end

  context "Instance Methods" do
  end

end

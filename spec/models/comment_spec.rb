require 'spec_helper'

describe Comment do
  # pending "add some examples to (or delete) #{__FILE__}"

  before(:all) do
    Show.destroy_all
    User.destroy_all
    @show = create(:show)
    @user = create(:user)
  end

  before(:each) do
    Comment.destroy_all
    @new_comment = Comment.new(:show_id => @show.id, :user_id => @user.id)
    @comment = create(:comment, :show_id => @show.id, :user_id => @user.id)
  end

  it{ should validate_presence_of(:user_id)  }
  it{ should validate_presence_of(:show_id)  }
  it{ should validate_presence_of(:user_name)  }
  it{ should validate_presence_of(:body)  }
  it{ should belong_to(:user) }
  it{ should belong_to(:show) }

  context "Class Methods" do
  end

  context "Instance Methods" do
  end

end

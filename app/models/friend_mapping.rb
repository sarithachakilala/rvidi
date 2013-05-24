class FriendMapping < ActiveRecord::Base

  # request_from is added to get to know from whom the request is 
  # comming, for showing respond to friend request
  attr_accessible :friend_id, :status, :user_id, :request_from
end

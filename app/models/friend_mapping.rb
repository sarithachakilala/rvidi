class FriendMapping < ActiveRecord::Base
  attr_accessible :friend_id, :status, :user_id, :request_from
end

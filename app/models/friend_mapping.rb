class FriendMapping < ActiveRecord::Base
  belongs_to :user
  scope :my_friend,
        proc {|current_user, director| where("user_id = ? AND friend_id = ? ",
                                   current_user.id, director.id)}
end

module Web
  class UsersController < Web::BaseController

    def search
      @users = User.where("username like ?  OR first_name like ? OR last_name like ? OR email like ? ",'%'+params[:search_val]+'%','%'+params[:search_val]+'%','%'+params[:search_val]+'%','%'+params[:search_val]+'%') if params[:search_val].present?
    end

    # Collect all the friends and Invite friends to contribute to the show if checked users or present
    def invite_friend
      # raise params.to_yaml
      friends_ids = params[:user_ids]
      @added_friends = FriendMapping.where(:user_id => current_user.id)
      user_to_send_friend_request = (friends_ids - @added_friends.collect(&:id))
      user_to_send_friend_request.each do |each_friend_id|
        @user = User.find(each_friend_id)
        # InviteFriend.create(:director_id=> @show.user_id, :show_id=> @show.id, :contributor_id=>@user.id, :status =>"invited" )
        @friend_mapping = FriendMapping.create(:user_id => current_user.id, :friend_id => each_friend_id, :request_from => current_user.id, :status =>"pending")
        # @friend_mapping = FriendMapping.create(:user_id => current_user.id, :friend_id => each_friend_id, :reuest_from => current_user.id, :status => "accepted")
        notification = Notification.new(:from_id=>current_user.id, :to_id=> each_friend_id, :status => "pending", :content=>" has Requested you to Add you as friend")
        notification.save!

        respond_to do |format|
          format.js{ flash.now[:notice] = 'Invitation sent Successfully'}
        end
      end
    end
  end
end

  class User::AccountsController < User::BaseController

    before_filter :get_user, :only => [:profile, :update, :show, :getting_started, :dashboard, :friends, :friend_profile]
    before_filter :require_user, :only => [:add_facebook_friends]
    before_filter :redirect_to_root_page, :only => [:index]

    def index
      @users = User.all

      respond_to do |format|
        format.html
        format.json { render json: @users }
      end
    end
    def new
      @user = User.new
      respond_to do |format|
        format.html {}
        format.json { render json: @user }
      end
    end

    def create
      @user = User.new(params[:user])
      if verify_recaptcha(:model => @user, :private_key=>'6Ld0H-ESAAAAAEEPiXGvWRPWGS37UvgaeSpjpFN2') && @user.save
        @success = true
        if params[:from_id].present?
          User.friendmapping_creation(params[:from_id], @user.id, "accepted")
          notifications = Notification.where(:to_email=>params[:from_email])
          notifications.each do |each_notification|
            each_notification.update_attributes(:to_id=> @user.id) unless (@user.id == params[:from_id])
          end
          invitations = InviteFriend.where(:contributor_email=>params[:from_email]) if params[:from_email].present?
          invitations.each do |each_invitation|
            each_invitation.update_attributes(:contributor_id=> @user.id)
          end if invitations.present?
          notification_update = Notification.where(:to_id => @user.id, :from_id => params[:from_id], :status=> "pending").first
          notification_update.update_attributes(:status => "accepted", :read_status => true) if notification_update.present?
        elsif params[:from_email].present?
          notifications = Notification.where(:to_email=>params[:from_email])
          notifications.each do |each_notification|
            each_notification.update_attributes(:to_id=> @user.id)
          end
          invitations = InviteFriend.where(:contributor_email=>params[:from_email])
          invitations.each do |each_invitation|
            each_invitation.update_attributes(:contributor_id=> @user.id)
          end
          User.friendmapping_creation(params[:invited_from], @user.id, "accepted")
        end
      else
        @success = false
        @user.errors.add(:error, "You have entered an invalid value for the captcha,please re-enter again!") if @user.errors[:base].present?
        @user.errors.delete(:base)
        flash[:error] =  @user.errors.full_messages.join(', ')
        flash[:recaptcha_error] = ""
      end
      respond_to do |format|
        if @success
          RvidiMailer.delay.welcome_email(@user)
          session[:user_id] = @user.id
          @user.increment_sign_in_count
          format.html{ redirect_to getting_started_user_account_path(@user.id), :notice => "Account Created Successfully!" }
          format.json{ render :json => { :status => 200, :user => @user } }
        else
          format.html{ render "new" }
          format.json { render json=>{ :errros => @user.errors, :status => 203 }}
        end
      end
    end

    def oauth_failure
      respond_to do|format|
        format.html{ redirect_to root_url, :notice => "Failure in Login!" }
        format.json { render json=>{ :errros => "Failure in Login!", :status => 401 }}
      end
    end

    def profile
      #    @profile_video = ProfileVideo.new
      respond_to do |format|
        format.html {}
        format.json { render json: @user }
      end
    end

    def update
      #    @profile_video = ProfileVideo.new
      #    if params[:user][:profile_video][:video_file].present?
      #      media_entry = @profile_video.upload_profile_video_to_kaltura(params[:user][:profile_video][:video_file], session[:client],
      #        session[:ks])
      #      @profile_video.set_uploaded_video_details(media_entry)
      #    end
      respond_to do |format|
        if @user.update_attributes(params[:user])
          format.html { redirect_to profile_user_account_path(@user), notice: 'User was successfully updated.' }
          format.json { render json: @user }
        else
          format.html { render action: "profile" }
          format.json { render json => { :errros => @user.errors, :status => 422 }}
        end
      end
    end

    def show
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @user }
      end
    end

    def getting_started
      @notifications = Notification.where(:status => "pending", :to_id=> current_user.id)
      @show_notifications = Notification.where(:to_id=> current_user.id)
    end

    def dashboard
      my_shows = Show.my_shows(current_user.id)
      my_friends = FriendMapping.where(:user_id => current_user.id, :status => "accepted").collect(&:friend_id)
      my_friends_show = Show.where(:user_id => my_friends)

      collected_shows = (my_shows + my_friends_show + Show.public_protected_shows).compact.uniq

      @most_viewed = collected_shows.sort_by { |show| show.number_of_views }.reverse
      @latest_show =  Show.limit(6).order('created_at desc')
      # @most_viewed =  Show.order('number_of_views desc')
    
      @show_notifications = Notification.where(:status => "contributed", :to_id=> current_user.id, :read_status => false).order(:created_at).group_by(&:show_id)
      @notifications = Notification.where(:to_id=> current_user.id, :status => "pending", :read_status => false)
      @cameo_invitations = Notification.where(:status => "contribute", :to_id=> current_user.id, :read_status => false)
      @cameo_contributors = Notification.where(:status => "others_contributed", :to_id=> current_user.id, :read_status => false).group_by(&:show_id)
      @newest_shows =  collected_shows.take(6).sort { |a, b| b.created_at <=>a.created_at }
      # @newest_shows =  Show.limit(6).order('created_at desc')
      @contributed_cameos = Cameo.where(:user_id => current_user.id)
      @commented_shows = Show.public_protected_shows.select("shows.id, count('comments.id') as comm_count").joins(:comments).group("shows.id")
      respond_to do |format|
        format.html
        format.json { render json: @user}
      end
  
    end

    def friends
      @friends = User.current_user_friends(current_user)
      if session[:uid].present?
        uid = session[:uid]
        client = User.configure_twitter(session[:auth_token], session[:auth_secret])
        session[:uid] = session[:auth_token] = session[:auth_secret] = nil
        begin
          @twitter_friends = client.followers(uid.to_i)
        rescue
          flash[:alert] = 'Twitter rake limit exceeded'
          redirect_to root_url
        end

      else
        @twitter_friends = []
      end
    end
  
    def friends_list
      @users = User.where("username like ?  OR first_name like ? OR last_name like ? OR email like ? ",'%'+params[:search_val]+'%','%'+params[:search_val]+'%','%'+params[:search_val]+'%','%'+params[:search_val]+'%') if params[:search_val].present?
    end

    def friend_profile
      @friend = User.find(params[:friend_id])
    end

    def notification
      @notifications =  Notification.where(:to_id => current_user.id).order(:updated_at)
      @friend_requests = Notification.where(:status => "pending", :to_id=> current_user.id, :read_status => false)
      @cameo_invitations = Notification.where(:status => "contribute", :to_id=> current_user.id, :read_status => false)
    end
  
    def send_friend_request
      @user = User.find(params[:friend_id])
      User.friendmapping_creation(current_user.id, @user.id, "pending")
      notification = Notification.new(:from_id=>current_user.id, :to_id=> @user.id, :status => "pending", :content=>"Requested to add as friend", :read_status => false)
      notification.save!
      redirect_to friends_user_account_path(:id => current_user.id), :notice => "Friend Request sent Successfully!"
    end

    def accept_friend_request
      friend_request1 = FriendMapping.where(:user_id =>params[:friend_id], :friend_id=> current_user.id).first
      friend_request1.update_attributes(:status =>"accepted") if friend_request1.present?
      friend_request2 = FriendMapping.create(:user_id =>current_user.id, :friend_id=> params[:friend_id], :status =>"accepted")
      notification = Notification.where(:to_id => current_user.id, :from_id => params[:friend_id]).first
      notification.update_attributes(:status => "accepted", :read_status => true)
      redirect_to notification_user_account_path(:id => current_user.id), :notice => "confirmed as friend!"
    end

    def ignore_friend_request
      friend_request1 = FriendMapping.where(:user_id =>params[:friend_id], :friend_id=> current_user.id).first
      friend_request1.update_attributes(:status =>"ignored") if friend_request1.present?
      notification = Notification.where(:to_id => current_user.id, :from_id => params[:friend_id],:status=>"ignored").first
      notification.update_attributes(:read_status => false) if notification.present?
      redirect_to notification_user_account_path(:id => current_user.id), :notice => "ignored friend Request!"
    end

    def invite_friend_via_email
      @user = User.find(params[:email_from])
      RvidiMailer.delay.invite_new_friend(params[:email], @user)
      notification = Notification.create(:to_email=> params[:email], :from_id => current_user.id, :status => "pending", :content =>"Requested to add as friend", :read_status => false)
      notification.save!
      redirect_to friends_user_account_path(:id => session[:user_id]), :notice => "Friend Request sent Successfully!"
    end

    def add_twitter_friends
      if session[:uid].present?
        uid = session[:uid]
        User.configure_twitter(session[:auth_token], session[:auth_secret])
        session[:uid] = session[:auth_token] = session[:auth_secret] = nil
        begin
          @twitter_friends = Twitter.followers(uid.to_i)
        rescue
          flash[:alert] = 'Twitter rake limit exceeded'
          redirect_to root_url
        end
      
      else
        @twitter_friends = []
      end
    end

    def add_facebook_friends
      @facebook_friends = params[:data]
    end

    private
    def get_user
      # Can we make it to be current_user always ??
      # @user = current_user
      @user = User.find(params[:id])
    end

  end


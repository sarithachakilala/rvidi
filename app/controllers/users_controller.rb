class UsersController < ApplicationController
  before_filter :get_user, :only => [:profile, :update, :show, :getting_started, :dashboard, :friends, :friend_profile]

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
      elsif params[:from_email].present?
        notifications = Notification.where(:to_email=>params[:from_email])
        notifications.each do |each_notification|
          each_notification.update_attributes(:to_id=> @user.id)
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
        session[:user_id] = @user.id
        @user.increment_sign_in_count
        format.html{ redirect_to getting_started_user_path(@user.id), :notice => "Account Created Successfully!" }
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
    respond_to do |format|
      format.html {}
      format.json { render json: @user }
    end
  end

  def update
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to profile_user_path(@user), notice: 'User was successfully updated.' }
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
    @notifications = Notification.where(:status => "pending", :to_id=> session[:user_id])
    @show_notifications = Notification.where(:to_id=> session[:user_id])
  end

  def dashboard
    @show_notifications = Notification.where(:status => "contributed", :to_id=> current_user.id, :read_status => false).order(:created_at).group_by(&:show_id)
    @notifications = Notification.where(:status => "pending", :to_id=> current_user.id, :read_status => false)
    @cameo_invitations = Notification.where(:status => "contribute", :to_id=> current_user.id, :read_status => false)
    @cameo_contributors = Notification.where(:status => "others_contributed", :to_id=> current_user.id, :read_status => false).group_by(&:show_id)
    respond_to do |format|
      format.html 
      format.json { render json: @user}
    end
  end

  def friends
    @friends = FriendMapping.where(:user_id => session[:user_id], :status =>"accepted")
  end

  def friends_list
    @users = User.where("username like ?  OR first_name like ? OR last_name like ? OR email like ? ",'%'+params[:search_val]+'%','%'+params[:search_val]+'%','%'+params[:search_val]+'%','%'+params[:search_val]+'%') if params[:search_val].present?
  end

  def friend_profile
    @friend = User.find(params[:friend_id])
  end

  def notification
    @notifications =  Notification.where(:to_id => current_user.id).order(:updated_at)
    @friend_requests = Notification.where(:status => "pending", :to_id=> session[:user_id], :read_status => false)
    @cameo_invitations = Notification.where(:status => "contribute", :to_id=> session[:user_id], :read_status => false)
  end
  
  def send_friend_request
    @user = User.find(params[:friend_id])
    User.friendmapping_creation(session[:user_id], @user.id, "pending")
    notification = Notification.new(:from_id=>session[:user_id], :to_id=> @user.id, :status => "pending", :content=>"Requested to add as friend", :read_status => false)
    notification.save!
    redirect_to friends_user_path(:id => session[:user_id]), :notice => "Friend Request sent Successfully!" 
  end

  def accept_friend_request
    friend_requst1 = FriendMapping.where(:user_id =>session[:user_id], :friend_id=> params[:friend_id]).first
    friend_requst2 = FriendMapping.where(:user_id =>params[:friend_id], :friend_id=> session[:user_id]).first
    notification = Notification.where(:to_id => session[:user_id], :from_id => params[:friend_id]).first
    friend_requst1.update_attributes(:status =>"accepted")
    friend_requst2.update_attributes(:status =>"accepted")
    notification.update_attributes(:status => "accepted")        
    redirect_to notification_user_path(:id => session[:user_id]), :notice => "confirmed as friend!"
  end

  def ignore_friend_request
    notification = Notification.where(:to_id => session[:user_id], :from_id => params[:friend_id]).first
    notification.update_attributes(:read_status => true)        
    redirect_to notification_user_path(:id => session[:user_id]), :notice => "Ingnored friend Request!"
  end

  def invite_friend_via_email
    @user = User.find(params[:email_from])
    RvidiMailer.delay.invite_new_friend(params[:email], @user)
    notification = Notification.create(:to_email=> params[:email], :from_id => session[:user_id], :status => "pending", :content =>"Requested to add as friend", :read_status => false) 
    notification.save!
    redirect_to friends_user_path(:id => session[:user_id])
  end

  def add_twitter_friends
    if twitter = current_user.authentications.find_by_provider("twitter")
      Twitter.configure do |tw|
        tw.consumer_key = configatron.twitter_consumer_key
        tw.consumer_secret = configatron.twitter_consumer_secret
        tw.oauth_token = twitter.oauth_token
        tw.oauth_token_secret = twitter.ouath_token_secret
      end
    @twitter_friends = Twitter.followers(current_user.username)
    else
      # TODO 
      # should not create a new user -> add this to the present user.
      redirect_to "/auth/twitter"
    end
  end

  def add_facebook_friends
    if facebook = current_user.authentications.find_by_provider("facebook")
      @facebook_friends = User.fetching_facebook
    else
      redirect_to "/auth/facebook"
    end
  end

  private
  def get_user
    # Can we make it to be current_user always ??
    # @user = current_user
    @user = User.find(params[:id])
  end

end


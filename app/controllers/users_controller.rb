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
        friendmapping_creation(@user)
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
  end

  def dashboard
    respond_to do |format|
      format.html 
      format.json { render json: @user}
    end
  end

  def friends
    @friends = FriendMapping.where(:user_id => session[:user_id], :status =>"accepted")
  end

  def friends_list
    @users = User.where("username like ? OR email like ?",'%'+params[:search_val]+'%','%'+params[:search_val]+'%') if params[:search_val].present?
  end

  def friend_profile
    @friend = User.find(params[:friend_id])
  end

  def notification
    @notifications = Notification.where(:status => "pending", :to_id=> session[:user_id])
  end
  
  def send_friend_request
    @user = User.find(params[:friend_id])
    RvidiMailer.invite_friend(@user).deliver
    friend_requst1 = FriendMapping.new(:user_id =>session[:user_id], :friend_id=>@user.id, :status => "pending", :request_from => session[:user_id])
    friend_requst2 = FriendMapping.new(:user_id =>@user.id, :friend_id=> session[:user_id], :status => "pending")
    notification = Notification.new(:from_id=>session[:user_id], :to_id=> @user.id, :status => "pending", :content=>"Requested to add as friend")
    friend_requst1.save!
    friend_requst2.save!
    notification.save!
    redirect_to friends_user_path(:id => session[:user_id])
  end

  def accept_friend_request
    friend_requst1 = FriendMapping.where(:user_id =>session[:user_id], :friend_id=> params[:friend_id]).first
    friend_requst2 = FriendMapping.where(:user_id =>params[:friend_id], :friend_id=> session[:user_id]).first
    notification = Notification.where(:to_id => session[:user_id], :from_id => params[:friend_id]).first
    friend_requst1.update_attributes(:status =>"accepted")
    friend_requst2.update_attributes(:status =>"accepted")
    notification.update_attributes(:status => "accepted")        
    redirect_to notification_user_path(:id => session[:user_id])
  end

  def invite_friend_via_email
    @user = User.find(params[:email_from])
    RvidiMailer.invite_new_friend(params[:email], @user).deliver
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

  def friendmapping_creation(user)
    @user= user
    friend_requst1 = FriendMapping.new(:user_id =>params[:from_id], :friend_id=>@user.id, :status => "accepted", :request_from => params[:from_id])
    friend_requst2 = FriendMapping.new(:user_id =>@user.id, :friend_id=> params[:from_id], :status => "accepted")
    friend_requst1.save!
    friend_requst2.save!
  end

  private
  def get_user
    # Can we make it to be current_user always ??
    # @user = current_user
    @user = User.find(params[:id])
  end

end

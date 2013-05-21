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
      @sucess = true
    else
      @sucess = false
      @user.errors.add(:error, "You have entered an invalid value for the captcha,please re-enter again!") if @user.errors[:base].present?
      @user.errors.delete(:base)
      flash[:error] =  @user.errors.full_messages.join(', ')
      flash[:recaptcha_error] = ""  
    end
    respond_to do |format|
      if @success
        format.html{ redirect_to root_url, :notice => "Account Created Successfully!" }
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
        format.html { render action: "edit" }
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
    @users = User.all 
  end

  def friends_list
    @users = User.all 
    @users = User.where("username like ? OR email like ?",'%'+params[:search_val]+'%','%'+params[:search_val]+'%') if params[:search_val].present?
  end

  def friend_profile
    @friend = User.find(params[:friend_id])
  end

  def send_friend_request
    @user = User.find(params[:friend_id])
    RvidiMailer.invite_friend(@user).deliver
    redirect_to friends_user_path(:id => session[:user_id])
  end

  private
  def get_user
    # Can we make it to be current_user always ??
    # @user = current_user
    @user = User.find(params[:id])
  end

end

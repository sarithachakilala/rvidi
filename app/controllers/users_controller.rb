class UsersController < ApplicationController
  before_filter :get_user, :only => [:profile, :update, :show, :getting_started, :dashboard, :friends, :friend_profile]

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if verify_recaptcha(:model => @user, :private_key=>'6Ld0H-ESAAAAAEEPiXGvWRPWGS37UvgaeSpjpFN2') && @user.save
      redirect_to root_url, :notice => "Account Created Successfully!"
    else
      @user.errors.add(:error, "You have entered an invalid value for the captcha,please re-enter again!") if @user.errors[:base].present?
      @user.errors.delete(:base)
      flash[:error] =  @user.errors.full_messages.join(', ')
      flash[:recaptcha_error] = ""  
      render "new"
    end
  end

  def oauth_failure
    redirect_to root_url, :notice => "Failure in Facebook Login!"
  end

  def profile
  end

  def update
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to profile_user_path(@user), notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
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
  end

  def friends
  end

  def friend_profile
    @friend = User.find(params[:friend_id])
  end

  private
  def get_user
    # Can we make it to be current_user always ??
    # @user = current_user
    @user = User.find(params[:id])
  end

end

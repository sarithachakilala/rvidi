class UsersController < ApplicationController
  before_filter :get_user, :only => [:profile, :update, :show, :getting_started, :dashboard, :friends, :friend_profile]

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if verify_recaptcha(:model => @user, :message => "Oh! It's error with reCAPTCHA!", :private_key=>'6Ld0H-ESAAAAAEEPiXGvWRPWGS37UvgaeSpjpFN2') && @user.save
    # if @user.save
      redirect_to root_url, :notice => "Account Created Successfully!"
    else
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
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
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

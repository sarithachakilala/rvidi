class SessionsController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => :create
  
  def new
    respond_to do |format|
      format.html{}
      format.json { render :json => {}}
    end
  end

  def create
    auth = env["omniauth.auth"]
    if auth.present? && ((auth.provider=="twitter") || (auth.provider=="facebook"))
      user = User.from_omniauth(auth)
    else
      user = User.authenticate(params[:login], params[:password]) 
    end
   if user
      session[:user_id] = user.id
      user.increment_sign_in_count
      user_login_path = (user.sign_in_count > 1) ? dashboard_user_path(user.id) : getting_started_user_path(user.id)
      redirect_to user_login_path, :notice => "Logged in Successfully!"
    else
      flash.now.alert = "Invalid email or password"
      render "new"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Logged out Successfully!"
  end
end

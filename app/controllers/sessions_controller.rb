class SessionsController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => :create
  def new
  end

  def create
    if params[:provider]=="facebook"
      user = User.from_omniauth(env["omniauth.auth"])
    elsif (env["omniauth.auth"].present? && (env["omniauth.auth"].provider=="twitter"))
      user = User.from_omniauth(env["omniauth.auth"])
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

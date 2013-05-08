class SessionsController < ApplicationController
  def new
  end

  def create
    if params[:provider]=="facebook"
      user = User.from_omniauth(env["omniauth.auth"])
    else
     user = User.authenticate(params[:login], params[:password]) 
   end

   if user
      session[:user_id] = user.id
      redirect_to profile_user_path(:id=>user.id), :notice => "Logged in!"
    else
      flash.now.alert = "Invalid email or password"
      render "new"
    end

  end

  def destroy
    reset_session
    session[:user_id] = nil
    redirect_to root_url, :notice => "Logged out!"
  end

end

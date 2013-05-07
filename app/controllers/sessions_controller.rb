class SessionsController < ApplicationController
  def new
  end

  def create
    if params[:provider]=="facebook"
      user = User.from_omniauth(env["omniauth.auth"])
    else
     user = User.authenticate(params[:login], params[:password]) 
   end

    if user == "Login with facebook"
      flash.now.alert = "Login with Facebook"
      render "new"
    elsif user
      session[:user_id] = user.id
      redirect_to root_url, :notice => "Logged in!"
    else
      flash.now.alert = "Invalid email or password"
      render "new"
    end

  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Logged out!"
  end

end

class SessionsController < ApplicationController
  def new
  end

  def create
    if env["omniauth.auth"]==""
     user = User.authenticate(params[:email], params[:password]) 
    else
      user = User.from_omniauth(env["omniauth.auth"])
    end
    if user
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

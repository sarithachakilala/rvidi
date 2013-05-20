class HomeController < ApplicationController

  def index
    respond_to do |format|
      format.html{}
      format.json { render json: user }
    end
  end

  def terms_condition
   
  end

  def authorize
    respond_to do |format|
      format.html # authorize.html.erb
    end
  end

  def invite_facebook_friends
  end
  
  def friends_list
    @friends = []
    params[:data].each do |each_friend|
      @friends <<  each_friend
    end
  end
end

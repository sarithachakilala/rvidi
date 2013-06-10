class HomeController < ApplicationController

  def index
    @all_shows = Show.all
    @latest_show = Show.last
    respond_to do |format|
      format.html{}
      format.json { render json: user }
    end
  end

  def terms_condition
  end

end

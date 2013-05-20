class HomeController < ApplicationController

  def index
    respond_to do |format|
      format.html{}
      format.json { render json: user }
    end
  end

  def terms_condition
   
  end

end

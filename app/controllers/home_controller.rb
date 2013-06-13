class HomeController < ApplicationController

  def index
    @all_shows = Show.all
    @latest_show =  Show.limit(6).order('created_at desc')
    @most_viewed =  Show.order('number_of_views desc')
    @most_commented = Show.select("shows.*, count('comments.id') as comm_count").joins(:comments).group("shows.id").order("comm_count desc")
    # @most_commented = Comment.count(:group =>"comments.show_id", :order=> "count_all desc")
    respond_to do |format|
      format.html{}
      format.json { render json: user }
    end
  end

  def terms_condition
  end

end

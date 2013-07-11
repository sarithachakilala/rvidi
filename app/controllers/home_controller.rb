class HomeController < ApplicationController
  before_filter :require_user, :only => [:video_player]

  def index
    @all_shows = Show.public_shows
    @newest_shows =  Show.public_shows.limit(6).order('created_at desc')
    @most_viewed =  Show.public_shows.order('number_of_views desc')
    @most_commented = Show.public_shows.select("shows.id, count('comments.id') as comm_count").joins(:comments).group("shows.id").order("comm_count desc")
    # @most_commented = Comment.count(:group =>"comments.show_id", :order=> "count_all desc")
    respond_to do |format|
      format.html{}
      format.json { render json: user }
    end
  end

  def terms_condition
  end

  def my_file
    send_file "#{Rails.root.to_s}/tmp/#{current_user.id}_#{session[:timestamp]}.flv", :type => 'video/x-flv'
  end

end

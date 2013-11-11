module Web
  class CommentsController < Web::BaseController

    before_filter :require_user, :only => [:new, :create, :destroy]

    def new
      @comment = Comment.new(:show_id => params[:show_id])

      respond_to do |format|
        format.js{}
        format.json { render json: @comment }
      end
    end

    def create
      @comment = Comment.new(params[:comment])
      @show = @comment.show
      @show_comments = Comment.get_latest_show_commits(@comment.show_id, 3)
      @all_comments = @show.comments
      @success = @comment.save

      respond_to do |format|
        if @success
          format.js{}
          format.json { render json: @comment }
        else
          format.js{}
          format.json { render json: @comment }
        end
      end
    end

    def show_all
      @show = Show.find(params[:show_id])
      @all_comments = @show.comments

      respond_to do |format|
        format.js{}
        format.json { render json: @all_comments }
      end
    end

  end

end

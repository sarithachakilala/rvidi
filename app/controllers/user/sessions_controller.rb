class User::SessionsController < User::BaseController
  skip_before_filter :verify_authenticity_token, :only => :create
  
  def new
    respond_to do |format|
      format.html{}
      format.json { render :json => {}}
    end
  end

  def create
    if (params[:fetch_invities].present? && params[:fetch_invities] == 'true')
      auth = env["omniauth.auth"]
      session[:uid] = auth['uid'].to_i
      session[:auth_token] = auth.credentials.token
      session[:auth_secret] = auth.credentials.secret
      logger.debug session[:uid]
      redirect_to edit_web_show_path(:id => params[:show_id])
    

    elsif (params[:fetch_friends].present? && params[:fetch_friends] == 'true')
      # Create Authentication recorda and map with current user
      auth = env["omniauth.auth"]
      # Redirect to appropriate add_friends page
      session[:uid] = auth['uid']
      session[:auth_token] = auth.credentials.token
      session[:auth_secret] = auth.credentials.secret
      logger.debug session[:uid]
      redirect_to friends_user_account_path(current_user.id)
    else
      auth = env["omniauth.auth"]
      if auth.present? && ((auth.provider=="twitter") || (auth.provider=="facebook"))
        user = User.from_omniauth(auth)
      else
        user = User.authenticate(params[:login], params[:password])
      end
      if user
        session[:user_id] = user.id
        user.increment_sign_in_count
        if(params[:invite_friend]== 'true')
          user_redirect_path =  friends_user_account_path(current_user.id)

        elsif (user.sign_in_count > 1)
          user_redirect_path =  dashboard_user_account_path(user.id)
        else
          user_redirect_path = auth.present? ? profile_user_account_path(user.id) :
                                    getting_started_user_account_path(user.id)
        end
      end
      @success = user.present? ? true :false

      respond_to do |format|
        if @success
          format.html{ redirect_back_or(user_redirect_path) }
          format.json{ render :json => { :status => 200, :user => user } }
        else
          format.html{
            flash.now.alert = "Invalid email or password"
            render "new"
          }
          format.json{ render :json => { :status => 401, :errors => ["Invalid email or password"] } }
        end
      end
    end
  end

  def destroy
    session[:user_id] = nil
    session[:display_preference] = nil
    session[:contribution_preference] = nil
    respond_to do|format|
      format.html{ redirect_to root_url, :notice => "Logged out Successfully!" }
      format.json { render json => { :status => 200 }}
    end
  end
end

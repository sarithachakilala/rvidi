class ApplicationController < ActionController::Base
  include SessionsHelper
  helper_method :current_user
  before_filter :set_locale, :get_kaltura_session

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  # METHODS for authentication redirections STARTS
  def require_user
    unless current_user.present?   
      store_location
      respond_to do |format|
        if params[:through]
          format.html{ redirect_to sign_up_path(:email =>params[:through], :invited_from =>params[:director_id]), :notice => "You need to Sign In / Register with rVidi to perform this Action" }
        else
          format.html{ redirect_to sign_in_path, :notice => "You need to Sign In / Register with rVidi to perform this Action" }
          format.js{ render "/shared/redirect_to_a_new_page", :locals=>{:url=>sign_in_path} }
          format.json { head :no_content }
        end
      end
    end
  end
  # METHODS for authentication redirections ENDS

  # To stub current_user method for cucumber specs. NEED TO BE VERIFIED AND UPDATED / REMOVED.
  if Rails.env.test?
    prepend_before_filter :stub_current_user
    def stub_current_user
      session[:user_id] = cookies[:stub_user_id] if cookies[:stub_user_id]
    end
  end

  private
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def get_kaltura_session
    begin
      if current_user.present?
        session[:client] ||= Cameo.get_kaltura_client(current_user.id)
        session[:ks] ||= session[:client].ks
        p "user loggedin! session is #{session[:ks]}"
      else
        session[:client] = nil
        session[:ks] = nil
      end
    rescue Kaltura::KalturaAPIError => e
      p "Handling Kaltura::KalturaAPIError exception ------- 1"
      p e.message
    end
  end

  protect_from_forgery
end

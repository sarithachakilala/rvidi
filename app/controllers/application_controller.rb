class ApplicationController < ActionController::Base
  helper_method :current_user
  before_filter :set_locale, :get_kaltura_session
 
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  private
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def get_kaltura_session
    if current_user.present?
      session[:client] ||= Video.get_kaltura_client
      session[:ks] ||= session[:client].ks
      p "user loggedin! session is #{session[:ks]}"
    else
      session[:client] = nil
      session[:ks] = nil
    end
  end

  protect_from_forgery
end

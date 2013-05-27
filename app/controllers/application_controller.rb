class ApplicationController < ActionController::Base
  helper_method :current_user
  before_filter :set_locale, :get_kaltura_session
 
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

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

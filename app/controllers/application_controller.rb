class ApplicationController < ActionController::Base
  include SessionsHelper
  helper_method :current_user
  before_filter :set_locale

  ## this function can be called in before filter of any controllers
  ## helpfull for paginating
  def parse_filters_from_url
    @current_page = params[:page] || "1"
    @per_page = params[:per_page] || "10"

    if @per_page && @per_page.to_i > 250
      @per_page = "10"
    end

    @offset = (@current_page.to_i - 1) * (@per_page.to_i)
    @query = params['query']

  end

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

  def redirect_to_root_page
    redirect_to current_user.present? ? dashboard_user_path(current_user.id) : root_url
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
    @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id].present?
  end


  protect_from_forgery
end

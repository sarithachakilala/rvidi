module ApplicationHelper

  def user_root_path
    current_user.present? ? dashboard_user_path(current_user) : root_path
  end
  
end

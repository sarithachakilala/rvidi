module ApplicationHelper

  def user_root_path
    current_user.present? ? dashboard_user_path(current_user) : root_path
  end
  
  def comment(&block)
		#block the content
	end
end

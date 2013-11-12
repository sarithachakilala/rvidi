module SpecTestHelper

  def login_admin
    login(:admin)
  end

  def login(user)
    user = User.where(:login => user.to_s).first if user.is_a?(Symbol)
    request.session[:user_id] = user.id
    current_user
  end

  def current_user
    controller.send :current_user
  end

end
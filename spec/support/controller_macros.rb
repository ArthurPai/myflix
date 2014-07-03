module ControllerMacros
  def set_current_user(user)
    session[:user_id] = user.id
  end
end
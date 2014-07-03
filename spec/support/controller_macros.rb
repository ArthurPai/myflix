module ControllerMacros
  def set_current_user(user)
    session[:user_id] = user.id
  end

  def clean_current_user
    session[:user_id] = nil
  end
end
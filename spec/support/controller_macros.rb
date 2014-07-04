module ControllerMacros
  def set_current_user
    john_doe = Fabricate(:user)
    session[:user_id] = john_doe.id
  end

  def current_user
    User.find(session[:user_id])
  end

  def clean_current_user
    session[:user_id] = nil
  end
end
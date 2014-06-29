class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user, :logged_in?

  def sign_in(user)
    session[:user_id] = user.id
  end

  def sign_out
    session[:user_id] = nil
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def require_login
    unless logged_in?
      flash[:warning] = 'Access reserved for members only. Please sign in first.'
      redirect_to root_path
    end
  end

  def require_not_login
    if logged_in?
      flash[:info] = 'You also logged in!'
      redirect_to home_path
    end
  end
end

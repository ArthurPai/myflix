class SessionsController < ApplicationController
  before_action :require_logged_in, only: [:destroy]
  before_action :require_not_login, only: [:new, :create]

  def new
  end

  def create
    user = User.find_by(email: params[:email])

    if user && user.authenticate(params[:password])
      flash[:success] = "Welcome back, #{user.full_name}"
      sign_in user
      redirect_to home_path
    else
      flash.now[:danger] = 'Something error of your email or password!!'
      render :new
    end
  end

  def destroy
    flash[:success] = "See you, #{current_user.full_name}"
    sign_out
    redirect_to root_path
  end

  private

    def require_logged_in
      unless logged_in?
        redirect_to root_path
      end
    end
end
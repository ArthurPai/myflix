class UsersController < ApplicationController
  before_action :require_not_login, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:success] = 'Register Succeed.'
      sign_in @user
      redirect_to home_path
    else
      render :new
    end
  end

  private

    def user_params
      params.require(:user).permit(:email, :password, :full_name)
    end
end
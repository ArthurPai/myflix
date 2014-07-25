class UsersController < ApplicationController
  before_action :require_login, only: [:show]
  before_action :require_not_login, only: [:new, :create]

  def new
    @user = User.new

    inviter = User.find_by_invitation_token(params[:invitation_token])
    if inviter
      @user.email = params[:email]
      @invitation_token = inviter.invitation_token
    end
  end

  def create
    @user = User.new(user_params)
    @invitation_token = params[:invitation_token]
    user_manager = UserManager.new(@user).sign_up(params[:stripeToken], @invitation_token)

    if user_manager.successful?
      flash[:success] = 'Register Succeed.'
      sign_in @user
      redirect_to home_path
    else
      flash.now[:danger] = user_manager.error_message
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  private

    def user_params
      params.require(:user).permit(:email, :password, :full_name)
    end

end
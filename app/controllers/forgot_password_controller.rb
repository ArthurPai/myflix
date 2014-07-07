class ForgotPasswordController < ApplicationController
  before_action 'require_not_login'

  def create
    user = User.find_by_email(params[:email])

    if user.present?
      UserMailer.reset_password_email(user).deliver
      redirect_to confirm_password_reset_path
    else
      flash[:danger] = 'There were something error!'
      redirect_to forgot_password_path
    end
  end
end
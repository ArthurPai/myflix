class ResetPasswordController < ApplicationController
  def new
    @reset_token = params[:reset_token]
    user = User.find_by_reset_password_token(@reset_token)
    redirect_to invalid_token_path if user.nil?
  end

  def create
    user = User.find_by_reset_password_token(params[:reset_token])

    redirect_to invalid_token_path and return if user.nil?

    password = params[:password]
    user.password = password
    if password.present? && user.save
      flash[:success] = 'Your password is changed. Please sign in with new password.'
      user.generate_token
      redirect_to login_path
    else
      flash[:warning] = password.blank? ? "Password can't blank" : 'Password is invalid'
      redirect_to reset_password_path(reset_token: params[:reset_token])
    end
  end
end
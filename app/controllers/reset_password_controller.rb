class ResetPasswordController < ApplicationController
  def new
    @reset_token = params[:reset_token]
    user = @reset_token.present? ? User.find_by_reset_password_token(@reset_token) : nil
    redirect_to invalid_token_path if user.nil?
  end

  def create
    reset_token = params[:reset_token]
    password = params[:password]

    # user = User.find_by_reset_password_token(reset_token)
    user = reset_token.present? ? User.find_by_reset_password_token(reset_token) : nil

    if user.present?
      user.password = password
      user.reset_password_token = nil
      if user.save
        redirect_to login_path
      else
        redirect_to reset_password_path
      end
    else
      redirect_to invalid_token_path
    end
  end
end
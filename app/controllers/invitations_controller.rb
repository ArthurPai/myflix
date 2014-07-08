class InvitationsController < ApplicationController
  before_action :require_login

  def create
    name = params[:name]
    email = params[:email]
    message = params[:message]

    if name.blank? || email.blank?
      flash.now[:danger] = 'There are some input invalid! Please check your input.'
      render :new
    else
      UserMailer.invitation_email(current_user, name, email, message).deliver
      flash[:success] = 'Invite is send to your friend'
      redirect_to invite_path
    end
  end
end
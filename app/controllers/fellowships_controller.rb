class FellowshipsController < ApplicationController
  before_action :require_login

  def index
  end

  def create
    user = User.find(params[:user_id])
    current_user.fellowships.create(followed_user: user) if current_user.can_follow?(user)
    redirect_to people_path
  end

  def destroy
    fellowship = current_user.fellowships.find_by(id: params[:id])
    fellowship.destroy if fellowship.present?
    redirect_to people_path
  end
end
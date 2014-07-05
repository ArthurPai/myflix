class FellowshipsController < ApplicationController
  before_action :require_login

  def index
  end

  def create
    user = User.find(params[:user_id])

    if user == current_user
      flash[:danger] = "You can't follow yourself."
      redirect_to people_path and return
    end

    fellowship = current_user.fellowships.build(followed_user: user)
    if fellowship.save
      flash[:success] = 'Follow success.'
    else
      flash[:info] = 'You are already following he/she.'
    end

    redirect_to people_path
  end

  def destroy
    fellowship = current_user.fellowships.find_by(id: params[:id])

    if fellowship.present?
      fellowship.destroy
      flash[:success] = 'Unfollow success.'
    else
      flash[:warning] = 'you can not do this!'
    end

    redirect_to people_path
  end
end
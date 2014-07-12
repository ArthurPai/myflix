class AdminController < AuthenticatedController
  before_action :require_admin

  private

  def require_admin
    unless current_user.admin?
      flash[:danger] = "You don't have permission to do that!"
      redirect_to home_path
    end
  end
end
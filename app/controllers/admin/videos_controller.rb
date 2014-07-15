class Admin::VideosController < AdminController
  def new
    @video = Video.new
    @categorys = Category.all
  end

  def create
    @video = Video.new(params_video)
    if @video.save
      flash[:success] = "You have successfully added the video '#{@video.title}'."
      redirect_to new_admin_video_path
    else
      @categorys = Category.all
      flash[:warning] = 'There were some input invalid!'
      render :new
    end
  end

  private

  def params_video
    params.require(:video).permit(:title, :description, :category_id, :large_cover, :large_cover_cache, :small_cover, :small_cover_cache)
  end
end
class CategoriesController < ApplicationController
  def show
    @category = Category.find(params[:id])
    @sort_type = params[:sort_type] || 'a-z'
    @videos = @category.videos.order(:title)

    if @sort_type == 'z-a'
      @videos.reverse_order!
    end

    respond_to do |format|
      format.html
    end
  end
end
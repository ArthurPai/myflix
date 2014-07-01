class QueueItemsController < ApplicationController
  before_action :require_login

  def index
    @queue_items = current_user.queue_items
  end

  def create
    video = Video.find(params[:video_id])

    if current_user.queue_items.find_by(video_id: video).nil?
      last_item = current_user.queue_items.order(:list_order).last
      list_order = last_item ? last_item.list_order+1 : 1
      queue_item = current_user.queue_items.new(list_order: list_order, video: video)
      queue_item.save

      redirect_to my_queue_path
    else
      flash[:warning] = 'This video already in your queue.'
      redirect_to video
    end
  end
end
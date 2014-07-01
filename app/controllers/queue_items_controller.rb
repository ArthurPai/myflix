class QueueItemsController < ApplicationController
  before_action :require_login

  def index
    @queue_items = current_user.queue_items
  end

  def create
    video = Video.find(params[:video_id])

    unless queue_video(video)
      flash[:warning] = 'This video already in your queue.'
    end

    redirect_to my_queue_path
  end

  def destroy
    queue_item = current_user.queue_items.find_by(id: params[:id])

    if queue_item.nil?
      flash.now[:danger] = "You don't have permission to remove this queue"
    else
      queue_item.destroy
      reorder_queue_items
    end

    @queue_items = current_user.queue_items
    render 'queue_items/index'
  end

  private

    def queue_video(video)
      queue_item = current_user.queue_items.build(list_order: new_order, video: video)
      queue_item.save
    end

    def new_order
      last_item = current_user.queue_items.order(:list_order).last
      current_order = last_item ? last_item.list_order : 0
      current_order + 1
    end

    def reorder_queue_items
      idx = 1
      current_user.queue_items.order('list_order').each do |queue_item|
        queue_item.update(list_order: idx)
        idx += 1
      end
    end
end
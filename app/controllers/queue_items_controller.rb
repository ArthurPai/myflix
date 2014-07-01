class QueueItemsController < ApplicationController
  before_action :require_login

  def index
    @queue_items = current_user.queue_items
  end

  def create
    video = Video.find(params[:video_id])
    queue_item = current_user.queue_items.new(list_order: new_order, video: video)

    unless queue_item.save
      flash[:warning] = 'This video already in your queue.'
    end

    redirect_to my_queue_path
  end

  private

    def new_order
      last_item = current_user.queue_items.order(:list_order).last
      current_order = last_item ? last_item.list_order : 0
      current_order + 1
    end
end
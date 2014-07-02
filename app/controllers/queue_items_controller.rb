class QueueItemsController < ApplicationController
  before_action :require_login

  def index
    @queue_items = current_user.queue_items
  end

  def create
    video = Video.find(params[:video_id])

    unless current_user.queue_video(video)
      flash[:warning] = 'This video already in your queue.'
    end

    redirect_to my_queue_path
  end

  def update
    unless queue_items_owner?
      flash[:danger] = 'You can not do this!!'
      redirect_to my_queue_path and return
    end

    if order_duplicate?
      flash[:warning] = 'There are some items has same order!'
      redirect_to my_queue_path and return
    end

    begin
      update_queue_items
    rescue ActiveRecord::RecordInvalid
      flash[:danger] = 'The order must be integer!'
    end
    redirect_to my_queue_path
  end

  def destroy
    queue_item = current_user.queue_items.find_by(id: params[:id])

    if queue_item.nil?
      flash[:danger] = "You don't have permission to remove this queue"
    else
      queue_item.destroy
      current_user.normalize_queue_items
    end

    redirect_to my_queue_path
  end

  private

    def queue_items_owner?
      params[:queue_items].each do |queue_item|
        item = QueueItem.find(queue_item[:id])
        return false unless item.user == current_user
      end
      true
    end

    # {1 => {list_order: '2'}, 2 => {list_order: '2'}, 3 => {list_order: '1'}}
    def order_duplicate?
      orders = params[:queue_items].map { |queue_item| queue_item[:list_order].to_f }
      # [2, 2, 1]

      duplicates = orders.each_with_index.reduce({}) { |hash, (item, index)|
        hash[item] = (hash[item] || []) << index
        hash
      }.select { |key, value|
        value.size > 1
      }
      # {2=>[0, 1]}

      !duplicates.blank?
    end

  def update_queue_items
    QueueItem.transaction do
      params[:queue_items].each do |queue_item|
        item = QueueItem.find(queue_item[:id])
        item.update!(list_order: queue_item[:list_order])
      end
    end

    current_user.normalize_queue_items
  end
end
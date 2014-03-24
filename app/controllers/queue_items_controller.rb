class QueueItemsController < ApplicationController
  before_filter :require_user

  def index
    @queue_items = current_user.queue_items
  end  

  def create
    video = Video.find(params[:video_id])
    queue_item = QueueItem.new(video: video, user_id: current_user.id, position: new_position)
    if queue_item.save
      redirect_to :my_queue
    else
      redirect_to video, notice: "This video is already in your queue"
    end
  end

  def destroy
    queue_item = QueueItem.find(params[:id])
    queue_item.destroy unless queue_item.user != current_user
    redirect_to :my_queue
  end

  def update_queue
    params[:queue_items].each do |queue_item_data|
      queue_item = QueueItem.find(queue_item_data["id"])
      queue_item.update_attributes(position: queue_item_data["position"] )
    end
    redirect_to :my_queue
  end

  private

  def new_position
    current_user.queue_items.count + 1
  end

end
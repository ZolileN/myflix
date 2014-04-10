class Admin::VideosController < ApplicationController
  before_action :require_user
  before_action :require_admin

  def new
    @video = Video.new
  end

  def create
    @video = Video.new(video_params)
    if @video.save
      flash[:success] = "You successfully created a video"
      redirect_to :new_admin_video
    else
      render :new
    end

  end

  private

  def require_admin
    if !current_user.admin?
      flash[:error] = "You can't do that."
      redirect_to :home
    end
  end

  def video_params
    params.require(:video).permit(:title, :description, category_ids: [])
  end
end
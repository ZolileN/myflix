class Admin::VideosController < ApplicationController
  before_action :require_user
  before_action :require_admin

  def new
    @video = Video.new
  end

  def require_admin
    if !current_user.admin?
      flash[:error] = "You can't do that."
      redirect_to :home
    end
  end
end
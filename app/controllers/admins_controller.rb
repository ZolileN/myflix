class AdminsController < ApplicationController
  before_action :require_admin

  private
  
  def require_admin
    if !current_user.admin?
      flash[:error] = "You can't do that."
      redirect_to :home
    end
  end
end
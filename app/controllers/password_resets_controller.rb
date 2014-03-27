class PasswordResetsController < ApplicationController

  def show
    @token = params[:id]
    user = User.where(token: @token).first
    redirect_to :expired_token unless user
  end

  def create
    user = User.where(token: params[:token]).first
    if user
      user.password = params[:password]
      user.generate_token
      user.save
      flash[:success] = "You have changed your password"
      redirect_to :sign_in
    else
      redirect_to :expired_token
    end
  end

end
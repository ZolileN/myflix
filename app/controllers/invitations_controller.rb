class InvitationsController < ApplicationController
  before_action :require_user

  def new
    @invitation = Invitation.new
  end
  
  def create
    @invitation = Invitation.new(invitation_params.merge!(inviter: current_user))
    if @invitation.save
      AppMailer.send_invitation_email(@invitation).deliver
      redirect_to :new_invitation
      flash[:success] = "You successfully invited someone to the site!"
    else
      render :new
    end
  end

  private

  def invitation_params
    params.require(:invitation).permit(:recipient_name, :recipient_email, :message)
  end

end
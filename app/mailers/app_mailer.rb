class AppMailer < ActionMailer::Base
  def send_welcome_email(user_id)
    user = User.find(user_id)
    @user = user
    mail to: user.email, from: "info@zacflix.herokuapp.com", subject: "Welcome to MyFlix yo!"
  end

  def send_forgot_password(user_id)
    user = User.find(user_id)
    @user = user
    mail to: user.email, from: "info@zacflix.herokuapp.com", subject: "Password Reset Request For Your Account"
  end

  def send_invitation_email(invitation_id)
    invitation = Invitation.find(invitation_id)
    @invitation = invitation
    @inviter = invitation.inviter
    mail to: invitation.recipient_email, from: "info@zacflix.herokuapp.com", subject: "You have been invited to join MyFlix!"
  end
end
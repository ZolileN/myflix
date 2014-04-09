class AppMailer < ActionMailer::Base
  def send_welcome_email(user)
    @user = user
    mail to: user.email, from: "info@zacflix.herokuapp.com", subject: "Welcome to MyFlix yo!"
  end

  def send_forgot_password(user)
    @user = user
    mail to: user.email, from: "info@zacflix@herokuapp.com", subject: "Password Reset Request For Your Account"
  end

  def send_invitation_email(invitation)
    @invitation = invitation
    @inviter = invitation.inviter
    mail to: invitation.recipient_email, from: "info@zacflix@herokuapp.com", subject: "You have been invited to join MyFlix!"
  end
end
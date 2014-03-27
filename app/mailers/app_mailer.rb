class AppMailer < ActionMailer::Base
  def send_welcome_email(user)
    @user = user
    mail to: user.email, from: "me@test.com", subject: "Welcome to MyFlix yo!"
  end

  def send_forgot_password(user)
    @user = user
    mail to: user.email, from: "me@test.com", subject: "Password Reset Request For Your Account"
  end
end
class UserMailer < ActionMailer::Base
  default from: 'baidragoon@gmail.com'

  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to Arthur Flex Site')
  end

  def reset_password_email(user)
    @user = user
    @reset_path = reset_password_url(reset_token: @user.reset_password_token)
    mail(to: @user.email, subject: 'Arthur Flex Password Reset')
  end
end
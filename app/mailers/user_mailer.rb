class UserMailer < ActionMailer::Base
  default from: 'baidragoon@gmail.com'

  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to Arthur Flex Site')
  end
end
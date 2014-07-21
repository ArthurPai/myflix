require 'spec_helper'

feature 'Resetting Password' do
  given!(:john) { Fabricate(:user, email: 'john@example.com', password: 'password', full_name: 'John Doe') }
  given!(:host) { Myflix::Application.config.action_mailer.default_url_options[:host] }
  background do
    clear_emails
    # puts Capybara.app_host = 'http://myflix.dev'
    # puts Capybara.default_host = 'http://myflix.dev'
    # puts Capybara.server_host = 'http://myflix.dev'
  end

  scenario 'sending reset password email to user and user reset the password' do
    visit login_path
    click_link 'Forgot Password?'
    fill_in 'Email Address', with: john.email
    click_button 'Send Email'

    open_email(john.email)
    current_email.click_link "http://#{host + reset_password_path(reset_token: john.reset_password_token)}"

    fill_in 'New Password', with: 'new_password'
    click_button 'Reset Password'

    fill_in 'Email Address', with: john.email
    fill_in 'Password', with: 'new_password'
    click_button 'Sign in'
    expect(page).to have_content "Welcome, #{john.full_name}"

    clear_emails
  end
end
require 'spec_helper'

feature 'Signing in' do
  background do
    @john = Fabricate(:user, email: 'john@example.com', password: 'password', full_name: 'John Doe')
  end

  scenario 'with correct credentials' do
    sign_in_user(@john.email, @john.password)
    expect(page).to have_content 'Welcome, John Doe'
    expect(page).to have_content 'Welcome back, John Doe'
  end

  scenario 'with incorrect credentials' do
    visit '/login'
    fill_in 'Email Address', with: 'some_one@example.com'
    fill_in 'Password', with: 'wrong_password'
    click_button 'Sign in'
    expect(page).to have_content 'Something error of your email or password!!'
  end

  scenario 'with deactivated user' do
    @john.deactivate!

    sign_in_user(@john.email, @john.password)
    expect(page).to have_content 'Your account has been suspended, please contact customer service.'
    expect(page).not_to have_content 'Welcome, John Doe'
    expect(page).not_to have_content 'Welcome back, John Doe'
  end
end
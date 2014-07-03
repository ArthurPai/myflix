require 'spec_helper'

feature 'Signing in' do
  background do
    @user = Fabricate(:user, email: 'john@example.com', password: 'password', full_name: 'John Doe')
  end

  scenario 'with correct credentials' do
    visit '/login'
    fill_in 'Email Address', with: @user.email
    fill_in 'Password', with: @user.password
    click_button 'Sign in'
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
end
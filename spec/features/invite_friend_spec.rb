require 'spec_helper'

feature 'User invite friend' do
  given!(:john) { Fabricate(:user, email: 'john@example.com', password: 'password', full_name: 'John Doe') }
  background do
    clear_emails
  end

  scenario 'invite friend and following each other when friend sign up', { js: true, vcr: true } do
    sign_in_user(john.email, john.password)

    invite_a_friend
    friend_accepts_invitation

    friend_sign_in
    friend_should_follow(john)
    friend_should_followed_by(john)

    clear_emails
  end

  def invite_a_friend
    visit '/invite'
    fill_in "Friend's Name", with: 'Jane'
    fill_in "Friend's Email Address", with: 'jane@example.com'
    fill_in 'Invitation Message', with: 'this is good site.'
    click_button 'Send Invitation'

    sign_out_user(john.full_name)
  end

  def friend_accepts_invitation
    open_email('jane@example.com')
    current_email.click_link 'Sign Up'
    # fill_in 'Email Address', with: 'jane@example.com'
    fill_in 'Password', with: 'password'
    fill_in 'Full Name', with: 'Jane Doe'
    fill_in 'Credit Card Number', with: '4242424242424242'
    fill_in 'Security Code', with: '314'
    select '12 - December', from: 'date_month'
    select 3.years.from_now.year, from: 'date_year'
    click_button 'Sign Up'
    expect(page).to have_content('Register Succeed.')
  end

  def friend_sign_in
    sign_out_user('Jane Doe')
    sign_in_user('jane@example.com', 'password')
  end

  def friend_should_follow(user)
    visit '/people'
    expect(page).to have_content(user.full_name)
    sign_out_user('Jane Doe')
  end

  def friend_should_followed_by(user)
    sign_in_user(user.email, user.password)
    visit '/people'
    expect(page).to have_content('Jane Doe')
  end
end
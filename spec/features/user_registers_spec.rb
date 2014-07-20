require 'spec_helper'

feature 'User registers', { js: true, vcr: true } do
  background do
    visit '/register'
  end

  scenario 'with valid personal and valid credit card' do
    fill_in_valid_personal_info
    fill_in_valid_credit_card
    click_button 'Sign Up'

    expect(page).to have_content 'Register Succeed.'
  end

  scenario 'with valid personal but invalid credit card' do
    fill_in_valid_personal_info
    fill_in_invalid_credit_card
    click_button 'Sign Up'

    expect(page).to have_content 'This card number looks invalid'
  end

  scenario 'with valid personal but declined credit card' do
    fill_in_valid_personal_info
    fill_in_declined_credit_card
    click_button 'Sign Up'

    expect(page).to have_content 'Your card was declined.'
  end

  scenario 'with invalid personal and valid credit card' do
    fill_in_invalid_personal_info
    fill_in_valid_credit_card
    click_button 'Sign Up'

    expect(page).to have_content 'Please fix the errors below.'
  end

  scenario 'with invalid personal and invalid credit card' do
    fill_in_invalid_personal_info
    fill_in_invalid_credit_card
    click_button 'Sign Up'

    expect(page).to have_content 'This card number looks invalid'
  end

  scenario 'with invalid personal and declined credit card' do
    fill_in_invalid_personal_info
    fill_in_declined_credit_card
    click_button 'Sign Up'

    expect(page).to have_content 'Please fix the errors below.'
  end

  def fill_in_valid_personal_info
    fill_in 'Email Address', with: 'john@example.com'
    fill_in 'Password', with: 'password'
    fill_in 'Full Name', with: 'John Doe'
  end

  def fill_in_invalid_personal_info
    fill_in 'Email Address', with: ''
    fill_in 'Password', with: 'password'
    fill_in 'Full Name', with: 'John Doe'
  end

  def fill_in_valid_credit_card
    fill_in 'Credit Card Number', with: '4242424242424242'
    fill_in 'Security Code', with: '314'
    select '12 - December', from: 'date_month'
    select '2018', from: 'date_year'
  end

  def fill_in_invalid_credit_card
    fill_in 'Credit Card Number', with: '1234'
    fill_in 'Security Code', with: '314'
    select '12 - December', from: 'date_month'
    select '2018', from: 'date_year'
  end

  def fill_in_declined_credit_card
    fill_in 'Credit Card Number', with: '4000000000000002'
    fill_in 'Security Code', with: '314'
    select '12 - December', from: 'date_month'
    select '2018', from: 'date_year'
  end
end
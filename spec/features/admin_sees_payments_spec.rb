require 'spec_helper'

feature 'Admin sees payments' do
  background do
    john = Fabricate(:user, email:'john@example.com', full_name: 'John Doe')
    payment = Fabricate(:payment, user: john, amount:999, reference_id: 'ch_12345678')
  end

  scenario 'admin can see payments' do
    admin = Fabricate(:admin)
    sign_in_user(admin.email, admin.password)
    visit admin_payments_path
    expect(page).to have_content('$9.99')
    expect(page).to have_content('john@example.com')
    expect(page).to have_content('John Doe')
    expect(page).to have_content('ch_12345678')
  end

  scenario 'user cannot see payments' do
    user = Fabricate(:user)
    sign_in_user(user.email, user.password)
    visit admin_payments_path
    expect(page).not_to have_content('$9.99')
    expect(page).not_to have_content('john@example.com')
    expect(page).not_to have_content('John Doe')
    expect(page).not_to have_content('ch_12345678')
    expect(page).to have_content("You don't have permission to do that!")
  end
end
def sign_in_user(email, password)
  visit '/login'
  fill_in 'Email Address', with: email
  fill_in 'Password', with: password
  click_button 'Sign in'
end
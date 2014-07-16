require 'spec_helper'

feature 'Admin Add new video' do
  given!(:admin) { Fabricate(:admin) }
  given!(:john) { Fabricate(:user, email: 'john@example.com', password: 'password', full_name: 'John Doe') }
  given!(:dramas) { Fabricate(:category, name: 'Tv Comedies') }
  given!(:dramas) { Fabricate(:category, name: 'TV Dramas') }

  scenario 'admin successfully added new video' do
    sign_in_user(admin.email, admin.password)

    visit '/admin/videos/new'

    fill_in 'Title', :with => 'Mozu'
    select 'TV Dramas', :from => 'Category'
    fill_in 'Description', :with => 'Video description.'
    attach_file 'Large Cover', File.join(Rails.root, 'app/assets/images/covers/monk_large.jpg')
    attach_file 'Small Cover', File.join(Rails.root, 'app/assets/images/covers/monk.jpg')
    fill_in 'Video URL', :with => 'http://arthurflix.s3.amazonaws.com/videos/ff14.mp4'
    click_button 'Add Video'

    sign_out_user
    sign_in_user(john.email, john.password)

    visit home_path
    expect(page).to have_selector("img[src='#{Rails.root}/spec/support/uploads/video/1/small_cover.png']")

    click_link 'video-1'
    expect(page).to have_content('Mozu')
    expect(page).to have_content('Video description.')
    expect(page).to have_selector("video[src='http://arthurflix.s3.amazonaws.com/videos/ff14.mp4']")
    expect(page).to have_selector("video[poster='#{Rails.root}/spec/support/uploads/video/1/large_cover.png']")
  end
end
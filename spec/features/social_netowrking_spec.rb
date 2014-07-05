require 'spec_helper'

feature 'Social Networking' do
  given!(:john) { Fabricate(:user, email: 'john@example.com', password: 'password', full_name: 'John Doe') }
  given!(:fiona) { Fabricate(:user, email: 'fiona@example.com', password: 'password', full_name: 'Fiona Cheng') }
  given!(:dramas) { Fabricate(:category, name: 'TV Dramas') }
  given!(:video_monk) { Fabricate(:video, title: 'Monk', category: dramas) }
  given!(:video_kanbe) { Fabricate(:video, title: '軍師官兵衛', category: dramas) }
  given!(:video_thrones) { Fabricate(:video, title: 'Game of Thrones', category: dramas) }

  background do
    Fabricate(:review, user: fiona, video: video_monk)
    Fabricate(:queue_item, user: fiona, video: video_monk)
    Fabricate(:queue_item, user: fiona, video: video_kanbe)
    Fabricate(:queue_item, user: fiona, video: video_thrones)
  end

  scenario 'follow and unfollow the other user' do
    sign_in_user(john.email, john.password)

    visit video_path(video_monk)
    click_link fiona.full_name
    expect(page).to have_content("#{fiona.full_name}'s video collections (#{fiona.queue_items.count})")
    expect(page).to have_content("#{fiona.full_name}'s Reviews (#{fiona.reviews.count})")

    click_link 'Follow'
    expect(page).to have_content('People I Follow')
    expect(find('tr:first-child td:first-child')).to have_content(fiona.full_name)
    expect(find('tr:first-child td:nth-child(2)')).to have_content('3')
    expect(find('tr:first-child td:nth-child(3)')).to have_content('1')

    click_link fiona.full_name
    expect(page).not_to have_link('Follow')

    visit people_path
    find('tr:first-child td:nth-child(4) a').click
    expect(page).not_to have_content(fiona.full_name)
  end
end
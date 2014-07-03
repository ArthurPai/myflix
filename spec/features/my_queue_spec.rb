require 'spec_helper'

feature 'User manager My Queue' do
  given!(:john) { Fabricate(:user, email: 'john@example.com', password: 'password', full_name: 'John Doe') }
  given!(:dramas) { Fabricate(:category, name: 'TV Dramas') }
  given!(:video_monk) { Fabricate(:video, title: 'Monk', category: dramas) }
  given!(:video_kanbe) { Fabricate(:video, title: '軍師官兵衛', category: dramas) }
  given!(:video_thrones) { Fabricate(:video, title: 'Game of Thrones', category: dramas) }

  scenario 'adds video to my queue and reorder queue items' do
    sign_in_user(john.email, john.password)

    click_link "video-#{video_monk.id}"
    expect(page).to have_content(video_monk.title)
    expect(page).to have_content(video_monk.description)

    click_link '+ My Queue'
    expect(page).to have_content('My Queue')
    expect(page).to have_content(video_monk.title)

    visit video_path(video_monk)
    expect(page).not_to have_link '+ My Queue'

    add_video_to_my_queue(video_kanbe)
    add_video_to_my_queue(video_thrones)

    visit my_queue_path
    set_new_order_to_queue_item(video_monk,    5)
    set_new_order_to_queue_item(video_kanbe,   3)
    set_new_order_to_queue_item(video_thrones, 4)

    click_button 'Update Instant Queue'

    expect_order_of_queue_item(video_kanbe,   1)
    expect_order_of_queue_item(video_thrones, 2)
    expect_order_of_queue_item(video_monk,    3)
  end

  def add_video_to_my_queue(video)
    visit home_path
    click_link "video-#{video.id}"
    click_link '+ My Queue'
  end

  def set_new_order_to_queue_item(video, order_list)
    within("tr[data-queue-item-id='#{video.id}']") do
      fill_in 'queue_items__list_order', :with => order_list.to_s
    end
  end

  def expect_order_of_queue_item(video, order_list)
    within("tr[data-queue-item-id='#{video.id}']") do
      expect(find('#queue_items__list_order').value).to eq(order_list.to_s)
    end
  end
end
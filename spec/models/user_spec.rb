require 'spec_helper'

describe User do
  it { should have_secure_password }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_presence_of(:full_name) }
  it { should validate_uniqueness_of(:email) }

  it { should have_many(:queue_items) }
  it { should have_many(:reviews).order('created_at desc') }

  let(:user) { Fabricate(:user) }
  let(:video_1) { Fabricate(:video) }
  let(:video_2) { Fabricate(:video) }
  let(:video_3) { Fabricate(:video) }

  it '#normalize_queue_items' do
    queue_item_1 = Fabricate(:queue_item, list_order: 4, user: user, video: video_1)
    queue_item_2 = Fabricate(:queue_item, list_order: 5, user: user, video: video_2)
    queue_item_3 = Fabricate(:queue_item, list_order: 2, user: user, video: video_3)

    user.normalize_queue_items
    expect(queue_item_1.reload.list_order).to eq(2)
    expect(queue_item_2.reload.list_order).to eq(3)
    expect(queue_item_3.reload.list_order).to eq(1)
  end

  it '#queue_video' do
    user.queue_video(video_1)
    expect(user.queue_items.count).to eq(1)
  end


  describe '#queued_video?' do
    before do
      Fabricate(:queue_item, list_order: 1, user: user, video: video_1)
    end

    it { expect(user.queued_video?(video_1)).to be_truthy }
    it { expect(user.queued_video?(video_2)).to be_falsey }
  end

end
require 'spec_helper'

describe QueueItem do
  it { should belong_to(:video) }
  it { should belong_to(:user) }
  it { should respond_to(:list_order) }

  it { should validate_presence_of(:video) }
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:list_order) }
  it { should validate_uniqueness_of(:video_id).scoped_to(:user_id) }

  describe '#video_title' do
    it 'returns title of associated video' do
      video = Fabricate(:video, title: 'Mozu')
      item = Fabricate(:queue_item, video: video)

      expect(item.video_title).to eq('Mozu')
    end
  end

  describe '#category' do
    it 'returns category of associated video' do
      cat = Fabricate(:category, name: 'TV Dramas')
      video = Fabricate(:video, category: cat)
      item = Fabricate(:queue_item, video: video)

      expect(item.category).to eq(cat)
    end
  end

  describe '#category_name' do
    it 'returns category name of associated video' do
      cat = Fabricate(:category, name: 'TV Dramas')
      video = Fabricate(:video, category: cat)
      item = Fabricate(:queue_item, video: video)

      expect(item.category_name).to eq('TV Dramas')
    end
  end

  describe '#rating' do
    it 'returns rating if associated user has review the associated video' do
      user = Fabricate(:user)
      video = Fabricate(:video)
      review = Fabricate(:review, user: user, video: video, rating: 3)
      item = Fabricate(:queue_item, user: user, video: video)

      expect(item.rating).to eq(review.rating)
    end

    it 'returns nil if associated user are not review the associated video' do
      user = Fabricate(:user)
      video = Fabricate(:video)
      item = Fabricate(:queue_item, user: user, video: video)

      expect(item.rating).to be_nil
    end
  end
end
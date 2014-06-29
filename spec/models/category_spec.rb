require 'spec_helper'

describe Category do
  it { should have_many(:videos).order('title asc') }

  describe 'recent videos' do
    let!(:cat) { Fabricate(:category, videos: []) }

    it 'returns empty array if dose not have any videos' do
      expect(cat.recent_videos).to eq([])
    end

    it 'returns all the videos if there are less then 6 videos' do
      Fabricate(:video, category: cat)
      Fabricate(:video, category: cat)

      expect(cat.recent_videos.count).to eq(2)
    end

    it 'returns the videos in the reverse order by created time' do
      video_old = Fabricate(:video, category: cat, created_at: 1.days.ago)
      video_new = Fabricate(:video, category: cat)

      expect(cat.recent_videos).to eq([video_new, video_old])
    end

    it 'returns an array of 6 videos if there are more then 6 videos' do
      videos = []
      Fabricate(:video, category: cat, created_at: 1.days.ago)
      6.times { |i| videos << Fabricate(:video, category: cat, created_at: i.seconds.ago) }

      expect(cat.recent_videos.count).to eq(6)
      expect(cat.recent_videos).to eq(videos)
    end
  end
end
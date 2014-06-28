require 'spec_helper'

describe Category do
  it { should have_many(:videos).order('title asc') }

  describe 'recent videos' do
    it 'returns the videos in the reverse order by created time' do
      cat = Category.create(name: 'Commedies')
      video1 = Video.create(title: "video 1", description: "video info 1", category: cat, created_at: 1.days.from_now)
      video2 = Video.create(title: "video 2", description: "video info 2", category: cat, created_at: 2.days.from_now)

      expect(cat.recent_videos).to eq([video2, video1])
    end

    it 'returns all the videos if there are less then 6 videos' do
      cat = Category.create(name: 'Commedies')
      video1 = Video.create(title: "video 1", description: "video info 1", category: cat, created_at: 1.days.from_now)
      video2 = Video.create(title: "video 2", description: "video info 2", category: cat, created_at: 2.days.from_now)

      expect(cat.recent_videos.count).to eq(2)
    end

    it 'returns an array of 6 videos if there are more then 6 videos' do
      cat = Category.create(name: 'Commedies')
      videos = []
      (1..8).each do |idx|
        video = Video.create(title: "video #{idx}", description: "video info #{idx}", category: cat, created_at: idx.days.from_now)
        videos << video if idx > 2
      end
      videos.reverse!

      expect(cat.recent_videos.count).to eq(6)
      expect(cat.recent_videos).to eq(videos)
    end

    it 'returns empty array if dose not have any videos' do
      cat = Category.create(name: 'Commedies')

      expect(cat.recent_videos).to eq([])
    end
  end
end
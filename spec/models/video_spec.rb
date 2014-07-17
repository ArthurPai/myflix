require 'spec_helper'
require 'shoulda/matchers'

describe Video do
  it { should belong_to(:category) }
  it { should have_many(:reviews).order('created_at desc') }
  it { should have_many(:queue_items) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:category) }

  describe 'search by title' do
    let!(:monk)       { Fabricate(:video, title: 'Monk', created_at: 2.days.ago) }
    let!(:monkey)     { Fabricate(:video, title: 'monkey', created_at: 1.days.ago) }
    let!(:south_park) { Fabricate(:video, title: 'South Park') }

    it 'returns an empty array if there is no match' do
      expect(Video.search_by_title('Transformer')).to eq([])
    end

    it 'returns an array of one video for an exact match' do
      expect(Video.search_by_title('South Park')).to eq([south_park])
    end

    it 'returns an array of one video for a partial match' do
      expect(Video.search_by_title('South')).to eq([south_park])
    end

    it 'returns an array of one video for case sensitive match' do
      expect(Video.search_by_title('south')).to eq([south_park])
    end

    it 'returns an array of all matches order by create time' do
      expect(Video.search_by_title('Monk')).to eq([monkey, monk])
    end

    it 'returns an empty array for a search with an empty string' do
      expect(Video.search_by_title('')).to eq([])
    end

    it 'returns an empty array for a search with an nil string' do
      expect(Video.search_by_title(nil)).to eq([])
    end
  end

  describe 'average_rating' do
    let!(:monk) { Fabricate(:video, title: 'Monk', created_at: 2.days.ago) }

    it 'return 0 if there is no review' do
      expect(monk.average_rating).to eq(0)
    end

    it 'return average if there has many reviews' do
      Fabricate(:review, video: monk, rating: 1)
      Fabricate(:review, video: monk, rating: 1)

      expect(monk.average_rating).to eql(1.0)
    end

    it 'return accurate to 1 decimal places if there has many reviews' do
      Fabricate(:review, video: monk, rating: 1)
      Fabricate(:review, video: monk, rating: 1)
      Fabricate(:review, video: monk, rating: 2)

      expect(monk.average_rating).to eq(1.3)
    end
  end
end
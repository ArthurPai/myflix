require 'spec_helper'

describe Video do
  it 'saved' do
    video = Video.new(title: 'First', description: 'First Video')

    video.save

    expect(Video.first).to eq(video)
  end

  it 'at category' do
    video = Video.create(title: 'First', description: 'First Video')
    cat = Category.create(name: 'TV')

    cat.videos << video
    
    expect(video.category).to eq(cat)
  end
end
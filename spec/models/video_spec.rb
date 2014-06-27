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

  it 'will save failed without title' do
    video = Video.new(description: 'Funny video')

    expect(video.save).to eq(false)
  end

  it 'will save failed without description' do
    video = Video.new(title: 'Monk')

    expect(video.save).to eq(false)
  end
end
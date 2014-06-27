require 'spec_helper'

describe Video do
  it 'saved' do
    video = Video.new(title: 'First', description: 'First Video')

    video.save

    expect(Video.first).to eq(video)
  end
end
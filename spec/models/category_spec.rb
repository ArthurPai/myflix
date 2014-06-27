require 'spec_helper'

describe Category do
  it 'saved' do
    cat = Category.new(name: 'TV')

    cat.save

    expect(Category.first).to eq(cat)
  end

  it 'has many videos' do
    cat = Category.create(name: 'TV')
    video1 = Video.create(title: 'First', description: 'First Video', category: cat)
    video2 = Video.create(title: 'Second', description: 'Second Video', category: cat)

    expect(Category.first.videos).to include(video1, video2)
  end
end
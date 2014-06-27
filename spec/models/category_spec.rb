require 'spec_helper'

describe Category do
  it 'saved' do
    cat = Category.new(name: 'TV')

    cat.save

    expect(Category.first).to eq(cat)
  end
end
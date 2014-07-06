require 'spec_helper'

describe VideosController do
  before { set_current_user }

  describe 'GET index' do
    before { Fabricate.times(3, :category) }

    it 'sets the @categories variable' do
      get :index
      expect(assigns(:categories)).to eq(Category.all)
    end

    it_behaves_like 'require sign in' do
      let(:action) { get :index }
    end
  end

  describe 'GET show' do
    let(:video) { Fabricate(:video) }

    it 'sets the @video variable' do
      get :show, id: video.id
      expect(assigns(:video)).to eq(video)
    end

    it 'sets the @review variable' do
      get :show, id: video.id
      expect(assigns(:review)).to be_instance_of(Review)
    end

    it 'sets the @reviews variable' do
      review_old = Fabricate(:review, video: video, created_at: 1.days.ago)
      review_new = Fabricate(:review, video: video)
      get :show, id: video.id
      expect(assigns(:reviews)).to eq([review_new, review_old])
    end

    it_behaves_like 'require sign in' do
      let(:action) { get :show, id: 0 }
    end
  end

  describe 'GET search' do
    let(:monk) { Fabricate(:video, title: 'monk') }

    it 'sets the @videos variable' do
      get :search, search: 'mon'
      expect(assigns(:videos)).to eq([monk])
    end

    it_behaves_like 'require sign in' do
      let(:action) { get :search, search: '' }
    end
  end
end
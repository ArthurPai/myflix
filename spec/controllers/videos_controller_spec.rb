require 'spec_helper'

describe VideosController do

  context 'with unauthenticated user' do
    describe 'GET index' do
      it 'redirect to root path' do
        get :index
        expect(response).to redirect_to(root_path)
      end
    end

    describe 'GET show' do
      it 'redirect to root path' do
        get :show, id: 0
        expect(response).to redirect_to(root_path)
      end
    end

    describe 'GET search' do
      it 'redirect to root path' do
        get :search, search: ''
        expect(response).to redirect_to(root_path)
      end
    end
  end

  context 'with authenticated user' do
    let!(:user) { Fabricate(:user) }
    before do
      set_current_user user
    end

    describe 'GET index' do
      before { Fabricate.times(3, :category) }

      it 'sets the @categories variable' do
        get :index
        expect(assigns(:categories)).to eq(Category.all)
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
    end

    describe 'GET search' do
      let(:monk) { Fabricate(:video, title: 'monk') }

      it 'sets the @videos variable' do
        get :search, search: 'mon'
        expect(assigns(:videos)).to eq([monk])
      end
    end
  end
end
require 'spec_helper'

describe ReviewsController do

  context 'with unauthenticated user' do
    describe 'POST create'
    it 'redirect to root_path' do
      post :create, video_id: 1, review: {rating: 5, content: ''}
      expect(response).to redirect_to root_path
    end
  end

  context 'with authenticated user' do
    let(:user) { Fabricate(:user) }
    let(:video) { Fabricate(:video) }
    before do
      login user
    end

    describe 'POST create' do
      context 'with valid input' do
        before do
          post :create, video_id: video.id, review: Fabricate.attributes_for(:review)
        end

        it 'redirect to video show page' do
          expect(response).to redirect_to video_path(video)
        end

        it 'creates a review' do
          expect(Review.count).to eq(1)
        end

        it 'creates a review association with the video' do
          expect(Review.first.video).to eq(video)
        end

        it 'creates a review association with current user' do
          expect(Review.first.user).to eq(user)
        end
      end

      context 'with invalid input' do

        it 'does not save review to database' do
          post :create, video_id: video.id, review: {rating: 5}
          expect(Review.count).to eq(0)
        end

        it 'render again video show template' do
          post :create, video_id: video.id, review: {rating: 5}
          expect(response).to render_template 'videos/show'
        end

        it 'sets @video variable' do
          post :create, video_id: video.id, review: {rating: 5}
          expect(assigns(:video)).to eq(video)
        end

        it 'sets @reviews variable' do
          review = Fabricate(:review, video: video)
          post :create, video_id: video.id, review: {rating: 5}
          expect(assigns(:reviews)).to eq([review])
        end

        it 'sets @review variable' do
          post :create, video_id: video.id, review: {rating: 5}
          expect(assigns(:review)).to be_instance_of(Review)
        end
      end
    end
  end
end
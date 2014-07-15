require 'spec_helper'

describe Admin::VideosController do
  describe 'GET new' do
    it_behaves_like 'require sign in' do
      let(:action) { get :new }
    end

    it_behaves_like 'require admin' do
      let(:action) { get :new }
    end

    context 'administrator' do
      before do
        set_current_admin
        get :new
      end

      it 'renders admin/videos/new template' do
        expect(response).to render_template 'admin/videos/new'
      end

      it 'sets @video variable' do
        expect(assigns(:video)).to be_a_new(Video)
      end

      it 'sets @categorys variable' do
        expect(assigns(:categorys)).to eq(Category.all)
      end
    end
  end

  describe 'post create' do
    it_behaves_like 'require sign in' do
      let(:action) { post :create, video: Fabricate.attributes_for(:video) }
    end

    it_behaves_like 'require admin' do
      let(:action) { post :create, video: Fabricate.attributes_for(:video) }
    end

    context 'administrator' do
      before { set_current_admin }

      context 'with valid input' do
        let!(:category) { Fabricate(:category) }
        let(:video) { Fabricate.attributes_for(:video, category: category) }

        it 'redirects to the new video page' do
          post :create, video: video
          expect(response).to redirect_to new_admin_video_path
        end

        it 'creates video' do
          post :create, video: video
          expect(Video.count).to eq(1)
        end

        it 'creates video association to the category' do
          post :create, video: video
          expect(category.reload.videos.count).to eq(1)
        end

        it 'sets flash success message' do
          post :create, video: video
          expect(flash[:success]).not_to be_blank
        end
      end

      context 'with invalid input' do
        let(:video) { Fabricate.attributes_for(:video, title: '') }

        it 'does not create video' do
          post :create, video: video
          expect(Video.count).to eq(0)
        end

        it 'renders admin/videos/new template' do
          post :create, video: video
          expect(response).to render_template :new
        end

        it 'sets @video variable' do
          post :create, video: video
          expect(assigns(:video)).to be_a_new(Video)
        end

        it 'sets @categorys variable' do
          post :create, video: video
          expect(assigns(:categorys)).to eq(Category.all)
        end

        it 'sets flash danger message' do
          post :create, video: video
          expect(flash[:warning]).not_to be_blank
        end
      end
    end
  end
end
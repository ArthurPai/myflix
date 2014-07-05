require 'spec_helper'

describe FellowshipsController do
  describe 'GET index' do
    it_behaves_like 'require sign in' do
      let(:action) { get :index }
    end
  end

  describe 'POST create' do
    let(:mia) { Fabricate(:user)}
    before do
      set_current_user
    end

    it 'redirects to people path' do
      post :create, user_id: mia.id
      expect(response).to redirect_to people_path
    end

    it 'creates fellowship that the current user following the other user' do
      post :create, user_id: mia.id
      expect(current_user.followed_users).to eq([mia])
    end

    it 'does not creates fellowship if current user also following this user' do
      Fellowship.create(follower: current_user, followed_user: mia)

      post :create, user_id: mia.id
      expect(Fellowship.count).to eq(1)
    end

    it 'does not allow one to follow themselves' do
      post :create, user_id: current_user.id
      expect(Fellowship.count).to be(0)
    end

    it_behaves_like 'require sign in' do
      let(:action) { post :create, user_id: 2 }
    end
  end

  describe 'DELETE destroy' do
    let(:mia) { Fabricate(:user)}
    before do
      set_current_user
    end

    it 'redirects to people path' do
      fellowship = Fellowship.create(follower: current_user, followed_user: mia)
      delete :destroy, id: fellowship.id
      expect(response).to redirect_to people_path
    end

    it 'deletes fellowship if current user is follower' do
      fellowship = Fellowship.create(follower: current_user, followed_user: mia)
      delete :destroy, id: fellowship.id
      expect(Fellowship.count).to eq(0)
    end

    it 'does not delete fellowship if current user is not follower' do
      fiona = Fabricate(:user)
      fellowship = Fellowship.create(follower: fiona, followed_user: mia)
      delete :destroy, id: fellowship.id
      expect(Fellowship.all).to eq([fellowship])
    end

    it_behaves_like 'require sign in' do
      let(:action) { delete :destroy, id: 1 }
    end
  end
end
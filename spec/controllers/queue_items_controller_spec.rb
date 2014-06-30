require 'spec_helper'

describe QueueItemsController do

  context 'with authenticated user' do
    let(:user) { Fabricate(:user) }
    before do
      login user
    end

    describe 'GET index' do
      it 'sets the @queues to the queue items of the current user' do
        item1 = Fabricate(:queue_item, list_order: 1, user: user)
        item2 = Fabricate(:queue_item, list_order: 2, user: user)
        Fabricate(:queue_item)

        get :index
        expect(assigns(:queue_items)).to match_array([item1, item2])
      end
    end
  end

  context 'with unauthenticated user' do
    describe 'GET index'
    it 'redirect to root_path' do
      get :index
      expect(response).to redirect_to root_path
    end
  end
end
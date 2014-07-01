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

    describe 'POST create' do
      context 'when video is not added before' do
        it 'redirects to the my queue path' do
          video = Fabricate(:video)

          post :create, video_id: video.id
          expect(response).to redirect_to(my_queue_path)
        end

        it 'add queue item to my queue of the logged in user' do
          video = Fabricate(:video)

          post :create, video_id: video.id
          expect(user.queue_items.count).to eq(1)
        end

        it 'add queue item and association with the video' do
          video = Fabricate(:video)

          post :create, video_id: video.id
          expect(QueueItem.first.video).to eq(video)
        end

        it 'sets list order be 1 of queue item when add to empty my queue' do
          video = Fabricate(:video)

          post :create, video_id: video.id
          expect(user.queue_items.first.list_order).to eq(1)
        end

        it 'increases list order of queue item when add to non empty my queue' do
          Fabricate(:queue_item, list_order: 1, user: user)
          Fabricate(:queue_item, list_order: 2, user: user)

          post :create, video_id: Fabricate(:video).id
          expect(user.queue_items.last.list_order).to eq(3)
        end

        it 'does not effect list order of queue item by other user queue items' do
          other_user = Fabricate(:user)
          video = Fabricate(:video)
          Fabricate(:queue_item, list_order: 1, video: video, user: other_user)

          post :create, video_id: video.id
          expect(user.queue_items.first.list_order).not_to eq(2)
        end
      end

      context 'when video is exist in the my queue' do
        let(:video) { Fabricate(:video) }
        before(:each) do
          Fabricate(:queue_item, list_order: 1, video: video, user: user)
        end

        it 'does not add same video to the my queue' do
          post :create, video_id: video.id
          expect(user.queue_items.count).to eq(1)
        end

        it 'redirect to my queue page' do
          post :create, video_id: video.id
          expect(response).to redirect_to my_queue_path
        end

        it 'displays the error flash message' do
          post :create, video_id: video.id
          expect(flash[:warning]).not_to be_blank
        end
      end
    end

    describe 'DELETE destroy' do
      it 'redirect to queue items index page' do
        queue_item = Fabricate(:queue_item, user: user)
        delete :destroy, id: queue_item.id
        expect(response).to redirect_to queue_items_path
      end

      it 'deletes the queue item' do
        queue_item = Fabricate(:queue_item, user: user)
        delete :destroy, id: queue_item.id
        expect(QueueItem.count).to eq(0)
      end

      it 'does not delete queue item if not the owner of queue item' do
        queue_item_owner = Fabricate(:user)
        queue_item = Fabricate(:queue_item, user: queue_item_owner)
        delete :destroy, id: queue_item.id
        expect(QueueItem.count).to eq(1)
      end

      it 'displays error flash message if not the owner of queue item to delete it' do
        queue_item_owner = Fabricate(:user)
        queue_item = Fabricate(:queue_item, user: queue_item_owner)
        delete :destroy, id: queue_item.id
        expect(flash[:danger]).not_to be_blank
      end

      it 'remove the video from the queue items of user' do
        Fabricate(:video)
        video2 = Fabricate(:video)
        queue_item = Fabricate(:queue_item, video: video2, user: user)
        delete :destroy, id: queue_item.id
        expect(QueueItem.where(video_id: video2.id, user_id: user.id)).to eq([])
      end

      it 'reorder all queue items of logged in user' do
        video1 = Fabricate(:video)
        video2 = Fabricate(:video)
        video3 = Fabricate(:video)
        queue_item3 = Fabricate(:queue_item, list_order: 3, video: video3, user: user)
        queue_item2 = Fabricate(:queue_item, list_order: 2, video: video2, user: user)
        queue_item1 = Fabricate(:queue_item, list_order: 1, video: video1, user: user)

        delete :destroy, id: queue_item2.id
        expect(QueueItem.find(queue_item1.id).list_order).to eq(1)
        expect(QueueItem.find(queue_item3.id).list_order).to eq(2)
      end
    end
  end

  context 'with unauthenticated user' do
    describe 'GET index' do
      it 'redirect to root_path' do
        get :index
        expect(response).to redirect_to root_path
      end
    end

    describe 'POST create' do
      it 'redirect to root_path' do
        post :create, video_id: Fabricate(:video).id
        expect(response).to redirect_to root_path
      end
    end

    describe 'DELETE destroy' do
      it 'redirect to root_path' do
        delete :destroy, id: 1
        expect(response).to redirect_to root_path
      end
    end
  end
end
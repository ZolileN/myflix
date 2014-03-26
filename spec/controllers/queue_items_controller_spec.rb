require 'spec_helper'

describe QueueItemsController do
  describe "GET index" do
    it "sets the @queue_items for the current, logged in user" do
      set_current_user
      video1 = Fabricate(:video)
      video2 = Fabricate(:video)
      queue_item1 = Fabricate(:queue_item, video: video1, user: current_user)
      queue_item2 = Fabricate(:queue_item, video: video2, user: current_user)
      get :index
      expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
    end

    it_behaves_like "requires sign in" do
      let(:action) { get :index }
    end

  end

  describe "POST create" do
    context "with authenticated user" do
      let(:fake_video) { Fabricate(:video) }
      before { set_current_user }
      it "redirects to the My Queue path " do
        post :create, video_id: fake_video.id
        expect(response).to redirect_to :my_queue
      end
      it "creates a queue item" do
        post :create, video_id: fake_video.id
        expect(QueueItem.count).to eq(1)
      end
      it "creates a queue item associated with the video" do
        post :create, video_id: fake_video.id
        expect(QueueItem.first.video_id).to eq(fake_video.id)
      end
      it "creates a queue item associated with the user" do
        post :create, video_id: fake_video.id
        expect(QueueItem.first.user_id).to eq(current_user.id)
      end
      it "puts the queue item at the end of the que list" do
        video2 = Fabricate(:video)
        Fabricate(:queue_item, video: video2, user: current_user)
        post :create, video_id: fake_video.id
        expect(QueueItem.last.position).to eq(2)
      end
      it "does not add a video to the queue if that video is already in the queue" do
        Fabricate(:queue_item, video: fake_video, user: current_user)
        post :create, video_id: fake_video.id
        expect(QueueItem.count).to eq(1)
      end

      it "redirects to the video page if the video is alread in the queue" do
        Fabricate(:queue_item, video: fake_video, user: current_user)
        post :create, video_id: fake_video.id
        expect(response).to redirect_to video_path(fake_video)
      end

    end
    context "with unauthenticated user" do
      it_behaves_like "requires sign in" do
        let(:action) { post :create, video_id: 3 }
      end
    end
  end

  describe "DELETE destroy" do
    let(:fake_video) { Fabricate(:video) }
    let(:fake_user) { Fabricate(:user) }
    let(:fake_queue_item) { Fabricate(:queue_item, video: fake_video, user: fake_user) }
     context "with authenticated user" do
      before { session[:user_id] = fake_user.id }
      it "redirects to the queue page" do
        delete :destroy, id: fake_queue_item
        expect(response).to redirect_to :my_queue
      end
      it "deletes the queue item" do
        delete :destroy, id: fake_queue_item
        expect(QueueItem.count).to eq(0)
      end
      it "normalizes the remaining queue items" do
        other_queue_item = Fabricate(:queue_item, user: fake_user, position: 2 )
        delete :destroy, id: fake_queue_item
        expect(other_queue_item.reload.position).to eq(1)
      end
      it "can not delete the queue item for another user" do
        other_user = Fabricate(:user)
        other_queue_item = Fabricate(:queue_item, video: fake_video, user: other_user)
        delete :destroy, id: other_queue_item
        expect(QueueItem.count).to eq(1)
      end
    end
    context 'with unauthenticated user' do
      it_behaves_like "requires sign in" do
        let(:action) { delete :destroy, id: fake_queue_item }
      end
    end
  end

  describe "POST update_queue" do
    let(:fake_video1) { Fabricate(:video) }
    let(:fake_video2) { Fabricate(:video) }

    context 'with valid inputs and authenticated user' do
      let(:fake_user) { Fabricate(:user) }
      let(:queue_item1) { Fabricate(:queue_item, video: fake_video1, position: 1, user: fake_user) }
      let(:queue_item2) { Fabricate(:queue_item, video: fake_video2, position: 2, user: fake_user) }

      before { session[:user_id] = fake_user.id }
      it "redirects to my_queue page" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(response).to redirect_to :my_queue
      end
      it "reorders queue_items" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(fake_user.queue_items).to eq([queue_item2, queue_item1])
      end
      it "normalizes the positions" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2}]
        expect(fake_user.queue_items.map(&:position)).to eq([1, 2])
      end
    end
    context 'with invalid inputs and authenticated user' do
      let(:fake_user) { Fabricate(:user) }
      let(:queue_item1) { Fabricate(:queue_item, video: fake_video1, position: 1, user: fake_user) }
      let(:queue_item2) { Fabricate(:queue_item, video: fake_video2, position: 2, user: fake_user) }

      before { session[:user_id] = fake_user.id }
      it "redirects to my_queue page" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2.8}, {id: queue_item2.id, position: 1}]
        expect(response).to redirect_to :my_queue
      end 
      it "sets the flash error message" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2.8}, {id: queue_item2.id, position: 1}]
        expect(flash[:error]).to be_present
      end
      it "doesn't change the queue_items" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2.8}]
        expect(queue_item1.reload.position).to eq(1)
      end
    end
    context 'with unauthenticated user' do
      let(:queue_item1) { Fabricate(:queue_item, video: fake_video1, position: 1) }
      let(:queue_item2) { Fabricate(:queue_item, video: fake_video2, position: 2) }
      it_behaves_like "requires sign in" do
        let(:action) { post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2}] }
      end
    end
    context 'with queue items belonging to another user' do
      it "doesn't change the queue items" do
        fake_user = Fabricate(:user)
        other_user = Fabricate(:user)
        session[:user_id] = other_user.id
        queue_item1 = Fabricate(:queue_item, user: fake_user, position: 1, video: fake_video1)
        queue_item2 = Fabricate(:queue_item, user: other_user, position: 2, video: fake_video2)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2}]
        expect(queue_item1.reload.position).to eq(1)
      end
    end
  end
end

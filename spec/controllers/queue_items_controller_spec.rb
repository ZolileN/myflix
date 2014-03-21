require 'spec_helper'

describe QueueItemsController do
  describe "GET index" do
    it "sets the @queue_items for the current, logged in user" do
      fake_user = Fabricate(:user)
      session[:user_id] = fake_user.id
      queue_item1 = Fabricate(:queue_item, user: fake_user)
      queue_item2 = Fabricate(:queue_item, user: fake_user)
      get :index
      expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
    end
    it "redirects to the sign in page for unauthenticated users" do
      get :index
      expect(response).to redirect_to :sign_in
    end
  end
end
require 'spec_helper'
describe RelationshipsController do

  describe "GET index" do
    it_behaves_like "requires sign in" do
      let(:action) { get :index }
    end
    it "sets @relationships to the current user's follwoing relationships" do
      follower = Fabricate(:user)
      set_current_user(follower)
      leader = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: follower, leader: leader)
      get :index
      expect(assigns(:relationships)).to eq([relationship]) 
    end
  end

  describe "DELETE destroy" do
    it_behaves_like "requires sign in" do
      let(:action) { delete :destroy, id: 4 }
    end
    it "deletes the relaionship if the current user is a follower" do
      follower = Fabricate(:user)
      set_current_user(follower)
      leader = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: follower, leader: leader)
      delete :destroy, id: relationship.id
      expect(Relationship.count).to eq(0) 
    end

    it "redirects to the people page" do
      follower = Fabricate(:user)
      set_current_user(follower)
      leader = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: follower, leader: leader)
      delete :destroy, id: relationship.id
      expect(response).to redirect_to :people
    end

    it "does not delete the relationship if the current user is not a follower" do
      follower = Fabricate(:user)
      bad_guy = Fabricate(:user)
      set_current_user(bad_guy)
      leader = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: follower, leader: leader)
      delete :destroy, id: relationship.id
      expect(Relationship.count).to eq(1)
    end
  end

end

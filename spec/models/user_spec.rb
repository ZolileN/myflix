require 'spec_helper'

describe User do
  it { should have_many(:reviews).order("created_at DESC") }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:full_name) }
  it { should validate_uniqueness_of(:email) }
  it { should have_many(:queue_items).order("position") }
  it { should have_many(:following_relationships).class_name("Relationship").with_foreign_key('follower_id') }
  it { should have_many(:leading_relationships).class_name("Relationship").with_foreign_key('leader_id') }

  it_behaves_like "tokeable" do
    let(:object) { Fabricate(:user) }
  end

  describe "#queued_video?" do
    it "returns true if the video is already in the user's queue" do
      fake_user = Fabricate(:user)
      video = Fabricate(:video)
      queue_item = Fabricate(:queue_item, video: video, user: fake_user)
      expect(fake_user.queued_video?(video)).to be_true 
    end
    it "returns false if the video is not in the user's queue" do
      fake_user = Fabricate(:user)
      video = Fabricate(:video)
      expect(fake_user.queued_video?(video)).to be_false 
    end
  end

  describe "#follows?" do
    it "returns true if the user is following the other user" do
      user = Fabricate(:user)
      other_user = Fabricate (:user)
      relationship = Fabricate(:relationship, leader: other_user, follower: user)
      expect(user.follows?(other_user)).to be_true
    end

    it "returns false if the user is not following the other user" do
      user = Fabricate(:user)
      other_user = Fabricate (:user)
      expect(user.follows?(other_user)).to be_false
    end
  end

  describe "#follow" do
    it "follows another user" do
      another_user = Fabricate(:user)
      user = Fabricate(:user)
      user.follow(another_user)
      expect(user.follows?(another_user)).to be_true
    end
    it "does not follow oneself" do
      user = Fabricate(:user)
      user.follow(user)
      expect(user.follows?(user)).to be_false
    end
  end

  describe "#deactivate" do
    it "deactivates an active user" do
      user = Fabricate(:user, active: true)
      user.deactivate!
      expect(User.first).not_to be_active 
    end
  end
  
end
class RelationshipsController < ApplicationController
  before_action :require_user
  def index
    @relationships = current_user.following_relationships
  end

  def destroy
    relationship = Relationship.find(params[:id])
    relationship.destroy unless current_user != relationship.follower
    redirect_to :people
  end

  def create
    follower = current_user
    leader = User.find(params[:leader_id])
    relationship = Relationship.new(follower: follower, leader: leader)
    relationship.save unless follower == leader
    redirect_to :people
  end

end
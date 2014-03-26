require 'spec_helper'

describe ReviewsController do
  describe "POST create" do
    let(:video) { Fabricate(:video) }
    context "with authenticated user" do
      before { set_current_user }
      context "with valid inputs" do

        before { post :create, review: Fabricate.attributes_for(:review), video_id: video.id }

        it "creates a review" do
          expect(Review.count).to eq(1)
        end
        it "creates a review associated with the video" do
          expect(Review.first.video_id).to eq(video.id)
        end
        it "creates a review associated with the signed in user" do
          expect(Review.first.user_id).to eq(current_user.id)
        end
        it "redirects to the video show page" do
          expect(response).to redirect_to video
        end

      end

      context "with invalid inputs" do
        before { post :create, review: Fabricate.attributes_for(:review, rating: nil), video_id: video.id }
        it "doesn't save the review" do
          expect(Review.count).to eq(0)
        end
        it "renders the video show template" do
          expect(response).to render_template 'videos/show'
        end
        it "sets @video" do
          expect(assigns(:video)).to eq(video)
        end
        it "sets @reviews" do
          video = Fabricate(:video)
          review = Fabricate(:review, video_id: video.id)
          post :create, review: {rating: nil }, video_id: video.id
          expect(assigns(:reviews)).to match_array([review])
        end
      end
    end

    context "with unauthenticated user" do
      it_behaves_like "requires sign in" do
        let(:action) { post :create, review: Fabricate.attributes_for(:review), video_id: video.id }
      end
    end
  end
end
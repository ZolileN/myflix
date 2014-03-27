require 'spec_helper'

describe UsersController do
  describe "GET new" do
    it "sets @user" do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  describe "POST create" do
    context 'with valid input' do
      before { post :create, user: Fabricate.attributes_for(:user) }
      it "creates the user" do
        expect(User.count).to eq(1)
      end
      it "redirects to the sign in page" do
        expect(response).to redirect_to :sign_in
      end

  
    end
    context 'with invalid input' do
      before { post :create, user: Fabricate.attributes_for(:user, email: nil) }
      it "does not create the user" do
        expect(User.count).to eq(0)
      end
      it "renders the new template" do
        expect(response).to render_template :new
      end
      it "sets @user" do
        expect(assigns(:user)).to be_instance_of(User)
      end
    end

    context "welcome emails" do
      after { ActionMailer::Base.deliveries.clear }
      let(:user) { { email: "user@fake.com", password: "password", full_name: "Spunky McTesterton" } }
      it "sends an email if there are valid inputs" do
        post :create, user: user
        expect(ActionMailer::Base.deliveries).not_to be_empty
      end
      it "sends email to correct email address if there are valid inputs" do
        post :create, user: user
        expect(ActionMailer::Base.deliveries.last.to).to eq([user[:email]])
      end
      it "sends email with correct body if there are valid inputs" do
        post :create, user: user
        expect(ActionMailer::Base.deliveries.last.body).to include("Welcome to MyFlix, #{user[:full_name]}")
      end
      it "does not send email if there are invalid inputs" do
        post :create, user: { password: "password", full_name: "Spunky McTesterton" }
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end

  end
  
  describe "GET show" do
    it_behaves_like "requires sign in" do
      let(:action) { get :show, id: 2 }
    end

    it "sets @user" do
      set_current_user
      get :show, id: current_user.id
      expect(assigns(:user)).to eq(current_user)
    end

  end
end
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
      after { ActionMailer::Base.deliveries.clear }
      it "creates the user" do
        post :create, user: Fabricate.attributes_for(:user)
        expect(User.count).to eq(1)
      end
      it "redirects to the sign in page" do
        post :create, user: Fabricate.attributes_for(:user)
        expect(response).to redirect_to :sign_in
      end
      it "makes the user follow the inviter" do
        inviter = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: inviter, recipient_email: "fake@fake.com")
        post :create, user: { email: 'fake@fake.com', password: "password", full_name: "John Doe" }, invitation_token: invitation.token
        user = User.where(email: "fake@fake.com").first
        expect(user.follows?(inviter)).to be_true
      end
      it "makes the inviter follow the user" do
        inviter = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: inviter, recipient_email: "fake@fake.com")
        post :create, user: { email: 'fake@fake.com', password: "password", full_name: "John Doe" }, invitation_token: invitation.token
        user = User.where(email: "fake@fake.com").first
        expect(inviter.follows?(user)).to be_true
      end
      it "expires the invitation upon acceptance" do
        inviter = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: inviter, recipient_email: "fake@fake.com")
        post :create, user: { email: 'fake@fake.com', password: "password", full_name: "John Doe" }, invitation_token: invitation.token
        user = User.where(email: "fake@fake.com").first
        expect(Invitation.first.token).to be_nil
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
        post :create, user: { password: "password" }
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

  describe "GET new_with_invitation_token" do
    it "renders new view template" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(response).to render_template :new
    end
    it "sets @user with recipient's email" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:user).email).to eq(invitation.recipient_email)
    end
    it "sets @invitation_token" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:invitation_token)).to eq(invitation.token)
    end
    it "redirects to expired token page for invalid tokens" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: 'fake_token'
      expect(response).to redirect_to :expired_token
    end
  end
end
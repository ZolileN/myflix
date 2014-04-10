require 'spec_helper'

describe InvitationsController do
  describe "GET new" do
    it_behaves_like "requires sign in" do
      let(:action) { get :new }
    end

    it "sets @invitation to a new invitation for a signed in user" do
      set_current_user
      get :new
      expect(assigns(:invitation)).to be_instance_of Invitation
    end
  end

  describe "POST create" do
    it_behaves_like "requires sign in" do
      let(:action) { post :create }
    end
    context 'with valid inputs' do
      after { ActionMailer::Base.deliveries.clear }
      it "creates an invitation" do
        recipient = Fabricate(:user)
        set_current_user
        post :create, invitation: { recipient_name: recipient.full_name, recipient_email: recipient.email, message: "Hello there, check out this site!" }
        expect(Invitation.count).to eql(1)
      end
      it "sends an email to the recipient" do
        recipient = Fabricate(:user)
        set_current_user
        post :create, invitation: { recipient_name: recipient.full_name, recipient_email: recipient.email, message: "Hello there, check out this site!" }
        expect(ActionMailer::Base.deliveries.last.to).to eq([recipient.email])
      end
      it "redirects to the invitation page" do
        recipient = Fabricate(:user)
        set_current_user
        post :create, invitation: { recipient_name: recipient.full_name, recipient_email: recipient.email, message: "Hello there, check out this site!" }
        expect(response).to redirect_to :new_invitation
      end
      it "sets the flash success message" do
        recipient = Fabricate(:user)
        set_current_user
        post :create, invitation: { recipient_name: recipient.full_name, recipient_email: recipient.email, message: "Hello there, check out this site!" }
        expect(flash[:success]).to be_present
      end
    end
    context 'with invalid inputs' do
      it "renders new template" do
        recipient = Fabricate(:user)
        set_current_user
        post :create, invitation: { recipient_email: recipient.email, message: "Hello there, check out this site!" }
        expect(response).to render_template :new
      end
      it "does not create invitation" do
        recipient = Fabricate(:user)
        set_current_user
        post :create, invitation: { recipient_email: recipient.email, message: "Hello there, check out this site!" }
        expect(Invitation.count).to eq(0)
      end
      it "does not send out email" do
        ActionMailer::Base.deliveries.clear
        recipient = Fabricate(:user)
        set_current_user
        post :create, invitation: { recipient_email: recipient.email, message: "Hello there, check out this site!" }
        expect(ActionMailer::Base.deliveries).to be_empty
      end
      it "sets @invitation" do
        recipient = Fabricate(:user)
        set_current_user
        post :create, invitation: { recipient_email: recipient.email, message: "Hello there, check out this site!" }
        expect(assigns(:invitation)).to be_present
      end
    end
  end  
end
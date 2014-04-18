require 'spec_helper'

describe UserSignup do
  describe "#sign_up" do
    context 'valid personal info and valid card' do
      after { ActionMailer::Base.deliveries.clear }
      let(:customer) { double(:customer, successful?: true) }
      before do 
        StripeWrapper::Customer.should_receive(:create).and_return(customer) 
      end

      it "creates the user" do
        UserSignup.new(Fabricate.build(:user)).sign_up("fake_stripe_token", nil)
        expect(User.count).to eq(1)
      end
      it "makes the user follow the inviter" do
        inviter = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: inviter, recipient_email: "fake@fake.com")
        UserSignup.new(Fabricate.build(:user, email: "fake@fake.com")).sign_up("fake_stripe_token", invitation.token)
        user = User.where(email: "fake@fake.com").first
        expect(user.follows?(inviter)).to be_true
      end
      it "makes the inviter follow the user" do
        inviter = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: inviter, recipient_email: "fake@fake.com")
        UserSignup.new(Fabricate.build(:user, email: "fake@fake.com")).sign_up("fake_stripe_token", invitation.token)
        user = User.where(email: "fake@fake.com").first
        expect(inviter.follows?(user)).to be_true
      end
      it "expires the invitation upon acceptance" do
        inviter = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: inviter, recipient_email: "fake@fake.com")
        UserSignup.new(Fabricate.build(:user, email: "fake@fake.com")).sign_up("fake_stripe_token", invitation.token)
        user = User.where(email: "fake@fake.com").first
        expect(Invitation.first.token).to be_nil
      end
      it "sends an email if there are valid inputs" do
        UserSignup.new(Fabricate.build(:user, email: "user@fake.com")).sign_up("fake_stripe_token", nil)
        expect(ActionMailer::Base.deliveries).not_to be_empty
      end
      it "sends email to correct email address if there are valid inputs" do
        UserSignup.new(Fabricate.build(:user, email: "user@fake.com")).sign_up("fake_stripe_token", nil)
        expect(ActionMailer::Base.deliveries.last.to).to eq(["user@fake.com"])
      end
      it "sends email with correct body if there are valid inputs" do
        UserSignup.new(Fabricate.build(:user, email: "user@fake.com", full_name: "Spunky McTesterton")).sign_up("fake_stripe_token", nil)
        expect(ActionMailer::Base.deliveries.last.body).to include("Welcome to MyFlix, Spunky McTesterton")
      end
    end

    context 'with valid personal info and declined card' do
      let(:customer) { double(:customer, successful?: false, error_message: "Your card was declined")  }
      it "does not create a new user" do
        StripeWrapper::Customer.stub(:create).and_return(customer)
        UserSignup.new(Fabricate.build(:user)).sign_up('1232132', nil)
        expect(User.count).to eq(0)
      end
    end

    context 'with invalid personal info' do
      before { UserSignup.new(Fabricate.build(:user, email: nil)).sign_up('1232132', nil)}
      it "does not create the user" do
        expect(User.count).to eq(0)
      end
      it "does not charge the card" do
        StripeWrapper::Customer.should_not_receive(:create)
      end
      it "does not send email if there are invalid inputs" do
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end

  end
end
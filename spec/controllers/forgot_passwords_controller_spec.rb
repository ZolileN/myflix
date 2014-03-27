require 'spec_helper'

describe ForgotPasswordsController do
  describe "POST create" do
    context "with blank input" do
      it "redirects to the forgot password page" do
        post :create, email: ''
        expect(response).to redirect_to :forgot_password 
      end
      it "shows an error message" do
        post :create, email: ''
        expect(flash[:error]).to eq("Email can not be blank")
      end
    end
    context 'with existing email' do
      it "redirects to the forgot password confirmation path" do
        user = Fabricate(:user)
        post :create, email: user.email
        expect(response).to redirect_to :forgot_password_confirmation
      end
      it "sends out an email to the email address" do
        user = Fabricate(:user)
        post :create, email: user.email
        expect(ActionMailer::Base.deliveries.last.to).to eq([user.email])
      end
    end
    context 'with a non-existant email' do
      it "redirects to the forgot password page" do
        post :create, email: "fake@fake.com"
        expect(response).to redirect_to :forgot_password
      end
      it "shows an error message" do
        post :create, email: "fake@fake.com"
        expect(flash[:error]).to eq("We can not find that email.")
      end
    end
  end
end
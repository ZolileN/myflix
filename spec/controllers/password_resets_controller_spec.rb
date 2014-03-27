require 'spec_helper'

describe PasswordResetsController do
 describe "GET show" do
   it "renders show template if the token is valid" do
    user = Fabricate(:user)
    get :show, id: user.token
    expect(response).to render_template :show
   end
   it "sets @token" do
    user = Fabricate(:user)
    get :show, id: user.token
    expect(assigns(:token)).to eq(user.token)
   end
   it "redirects to the expired token page if the token is invalid" do
    get :show, id: '12345'
    expect(response).to redirect_to :expired_token
   end
 end

 describe "POST create" do
   context "with valid token" do
     it "should update the user's password" do
      user = Fabricate(:user)
      post :create, token: user.token, password: 'new_password'
      expect(User.first.authenticate('new_password')).to be_true
     end
     it "should redirect to sign in page" do
      user = Fabricate(:user)
      post :create, token: user.token, password: 'new_password'
      expect(response).to redirect_to :sign_in
     end
     it "sets the flash success message" do
      user = Fabricate(:user)
      post :create, token: user.token, password: 'new_password'
      expect(flash[:success]).to eq("You have changed your password")
     end
     it "regenerates the user token" do
      user = Fabricate(:user)
      old_token = user.token
      post :create, token: user.token, password: 'new_password'
      expect(User.first.token).not_to eq(old_token)
     end
   end
   context "with invalid token" do
     it "redirects to the expired token path" do
       post :create, token: '12245', password: 'new_password'
       expect(response).to redirect_to :expired_token
     end
   end
 end
end
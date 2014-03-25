require 'spec_helper'

feature "user signs in" do
  scenario "with valid user email and password" do
    fake_user = Fabricate(:user)
    visit sign_in_path
    fill_in "Email Address", with: fake_user.email
    fill_in "Password", with: "password"
    click_button "Sign in"
    expect(page).to have_content fake_user.full_name 
  end
end
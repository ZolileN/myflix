require 'spec_helper'

feature "user signs in" do
  scenario "with valid user email and password" do
    fake_user = Fabricate(:user)
    sign_in(fake_user)
    expect(page).to have_content fake_user.full_name 
  end
  scenario "with deactivated user" do
    fake_user = Fabricate(:user)
    fake_user.deactivate!
    sign_in(fake_user)
    expect(page).not_to have_content fake_user.full_name
    expect(page).to have_content("Your account has been suspended, please contact customer service.")  
  end
  scenario "with invalid input" do
    fake_user = Fabricate(:user)
    visit sign_in_path
    fill_in "Email Address", with: fake_user.email
    fill_in "Password", with: ""
    click_button "Sign in"
    expect(page).to have_content "There is something wrong with your email or password."
    clear_email 
  end
end
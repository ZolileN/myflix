require 'spec_helper'

feature "User resets password" do
  scenario "user sucessfully resets the password" do
    fake_user = Fabricate(:user, password: "old_password")
    visit sign_in_path
    click_link "Forgot Password?"
    fill_in "Email Address", with: fake_user.email
    click_button "Send Email"

    open_email(fake_user.email)
    current_email.click_link("Reset My Password")

    fill_in "New Password", with: "new_password"
    click_button "Reset Password"

    fill_in "Email Address", with: fake_user.email
    fill_in "Password", with: "new_password"
    click_button "Sign in"

    expect(page).to have_content("Welcome, #{fake_user.full_name}")

    clear_email
  end
end
require 'spec_helper'

feature "User invites friend" do
  scenario "User sucessfully invites friend and invitation is accepted" do
    inviter = Fabricate(:user)
    sign_in(inviter)

    invite_friend
    invitation_accepted
    invitee_signs_in

    invitee_should_follow_inviter(inviter)
    inviter_should_follow_invitee(inviter)

    clear_email

  end

  def invite_friend
    visit new_invitation_path
    fill_in "Friend's Name", with: "John Doe"
    fill_in "Friend's Email", with: "fake@fake.com"
    fill_in "Invitation Message", with: "Hey check out this site"
    click_button "Send Invitation"
    sign_out
  end

  def invitation_accepted
    open_email "fake@fake.com"
    current_email.click_link "Join the Site!"

    fill_in "Password", with: "password"
    fill_in "Full Name", with: "John Doe"
    click_button "Sign Up"
  end

  def invitee_signs_in
    fill_in "Email Address", with: "fake@fake.com"
    fill_in "Password", with: "password"
    click_button "Sign in"
  end

  def invitee_should_follow_inviter(inviter)
    click_link "People"
    expect(page).to have_content inviter.full_name
    sign_out
  end
  def inviter_should_follow_invitee(inviter)
    sign_in(inviter)
    click_link "People"
    expect(page).to have_content "John Doe"
  end
end
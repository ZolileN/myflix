require 'spec_helper'

feature "User follows another user" do
  scenario "user follows and unfollows someone" do
    category = Fabricate(:category)
    video = Fabricate(:video, categories: [category])
    leader = Fabricate(:user)
    review = Fabricate(:review, user: leader, video: video)

    sign_in
    visit_video_page_from_home(video)
    
    click_link leader.full_name
    click_link "Follow"
    expect(page).to have_content(leader.full_name)

    unfollow(leader)
    expect(page).not_to have_content(leader.full_name)
    clear_email
  end

  def unfollow(user)
    find('a[data-method="delete"]').click
  end
end
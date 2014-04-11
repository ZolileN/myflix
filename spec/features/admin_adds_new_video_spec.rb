require 'spec_helper'

feature "Admin adds a new video" do
  scenario "admin sucessfully adds a new video" do
    sign_admin_in
    clear_videos
    category = Fabricate(:category)
    visit new_admin_video_path

    fill_in "Title", with: "Admin Added Video"
    select category.name, from: "Category"
    fill_in "Description", with: "This the description of this show"
    attach_file "Large Cover", "spec/support/uploads/large_cover.jpg"
    attach_file "Small Cover", "spec/support/uploads/small_cover.jpg"
    fill_in "Video URL", with: "http://fake.com/video.mp4"
    click_button "Add Video"

    sign_out
    sign_in
    
    visit video_path(Video.first)
    expect(page).to have_selector("img[src='/uploads/large_cover.jpg']")
    expect(page).to have_selector("a[href='http://fake.com/video.mp4']")
    clear_videos

  end
end
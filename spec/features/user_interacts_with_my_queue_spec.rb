require 'spec_helper'

feature "User interacts with the queue" do
  scenario "user adds and reorders videos in the queue" do
    comedies = Fabricate(:category, name: "TV Comedies")
    dramas = Fabricate(:category, name: "TV Dramas")
    monk = Fabricate(:video, title: "Monk", categories: [dramas])
    south_park = Fabricate(:video, title: "South Park", categories: [comedies])
    futurama = Fabricate(:video, title: "Futurama", categories: [comedies])
    
    sign_in
    
    add_video_to_queue(monk)
    expect_video_to_be_in_queue(monk)

    visit video_path(monk)
    expect_link_not_to_be_present("+ My Queue")

    add_video_to_queue(south_park)
    add_video_to_queue(futurama)

    set_video_position(monk, 3)
    set_video_position(south_park, 2)
    set_video_position(futurama, 2)
    update_queue

    expect_video_position(south_park, 1)
    expect_video_position(futurama, 2)
    expect_video_position(monk, 3)
  end

  def expect_video_to_be_in_queue(video)
    expect(page).to have_content(video.title)
  end

  def expect_link_not_to_be_present(link_text)
    expect(page).not_to have_content "#{link_text}"
  end

  def update_queue
    click_button "Update Instant Queue"
  end

  def add_video_to_queue(video)
    visit home_path
    find("a[href='/videos/#{video.id}']").click
    click_link "+ My Queue"
  end

  def set_video_position(video, position)
    fill_in "video_#{video.id}_queue_position", with: position
  end

  def expect_video_position(video, position)
    expect(find("#video_#{video.id}_queue_position").value).to eq("#{position}")
  end

end
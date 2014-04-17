require 'spec_helper'

feature "User registers", :js, :vcr do

  background { visit register_path }

  scenario "with valid user info and valid card" do
    enter_valid_user_info

    enter_credit_card('4242424242424242')
    click_button "Sign Up"

    expect(page).to have_content("Thank you for registering!")
  end
  scenario "with valid user info and invalid card" do
    enter_valid_user_info

    enter_credit_card('123')
    click_button "Sign Up"

    expect(page).to have_content("This card number looks invalid")
  end
  scenario "with valid user info and declined card" do
    enter_valid_user_info

    enter_credit_card('4000000000000002')
    click_button "Sign Up"

    expect(page).to have_content("Your card was declined.")
  end
  scenario "with invalid user info and valid card" do
    enter_invalid_user_info

    enter_credit_card('4242424242424242')
    click_button "Sign Up"

    expect(page).to have_content("Invalid user information. Please check the errors below.")
  end
  scenario "with invalid user info and invalid card" do
    enter_invalid_user_info

    enter_credit_card('123')
    click_button "Sign Up"
    expect(page).to have_content("This card number looks invalid")
  end
  scenario "with invalid user info and declined card" do
    enter_invalid_user_info

    enter_credit_card('4000000000000002')
    click_button "Sign Up"

    expect(page).to have_content("Invalid user information. Please check the errors below.")
  end

  def enter_valid_user_info
    fill_in "Email Address", with: "fake@fake.com"
    fill_in "Password", with: "password"
    fill_in "Full Name", with: "Fakey McTesterton"
  end  

  def enter_invalid_user_info
    fill_in "Email Address", with: "fake@fake.com"
  end

end
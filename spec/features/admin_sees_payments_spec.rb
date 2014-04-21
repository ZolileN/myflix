require 'spec_helper'

feature "Admin sees payments" do
  background do
    user = Fabricate(:user, full_name: "Fake User", email: "fake@fake.com")
    Fabricate(:payment, amount: 999, user: user)
  end
  scenario "admin can see payments" do
    sign_admin_in
    visit admin_payments_path
    expect(page).to have_content("$9.99")
    expect(page).to have_content("Fake User")
    expect(page).to have_content("fake@fake.com")   
  end
  scenario "user can not see payments" do
    sign_in
    visit admin_payments_path
    expect(page).not_to have_content("$9.99")
    expect(page).not_to have_content("Fake User")
    expect(page).not_to have_content("fake@fake.com")
    expect(page).to have_content("You can't do that.")   
  end
end
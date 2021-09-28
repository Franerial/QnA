require "rails_helper"

feature "User can sign out", %q{
  Authenticated user
  can log out
  to end the session
} do
  given(:user) { create(:user) }

  background do
    sign_in(user)
    visit root_path
  end

  scenario "Authenticated user tries to log out" do
    click_on "Logout"

    expect(page).to have_content "Signed out successfully."
  end
end

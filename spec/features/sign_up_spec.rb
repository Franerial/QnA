require "rails_helper"

feature "User can sign up", %q{
  In order to ask questions
  As an unauthenticated user
  I would like to be able to sign up
} do
  given(:user) { create(:user) }
  background { visit new_user_registration_path }

  describe "User has never been previously registered" do
    scenario "User tries to sign up with valid params" do
      fill_in "Email", with: attributes_for(:user)[:email]
      fill_in "Password", with: attributes_for(:user)[:password]
      fill_in "Password confirmation", with: attributes_for(:user)[:password_confirmation]
      click_on "Sign up"

      expect(page).to have_content "A message with a confirmation link has been sent to your email address. Please follow the link to activate your account."
    end

    scenario "User tries to sign up with invalid params" do
      fill_in "Email", with: "123456789"
      fill_in "Password", with: ""
      fill_in "Password confirmation", with: "123456789"
      click_on "Sign up"

      expect(page).to have_content "errors prohibited this user from being saved:"
    end
  end

  scenario "User was previously registered" do
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    fill_in "Password confirmation", with: user.password_confirmation
    click_on "Sign up"

    expect(page).to have_content "Email has already been taken"
  end
end

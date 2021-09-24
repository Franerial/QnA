require "rails_helper"

feature "User can create answer", %q{
  An authenticated user
  can create an answer to the corresponded question created by other users
  to help to solve their problems
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe "Authenticated user" do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario "Create answer" do
      fill_in "Body", with: "Text text text"
      click_on "Create"

      expect(page).to have_content "Your answer successfully created."
      expect(page).to have_content "Text text text"
    end

    scenario "Create answer with errors" do
      click_on "Create"
      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario "Unauthenticated user try to create answer" do
    visit question_path(question)
    click_on "Create"

    expect(page).to have_content "You need to sign in or sign up before continuing."
  end
end

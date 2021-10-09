require "rails_helper"

feature "User can edit his answer", %q{
  In order to correct mistakes
  As an author of answer
  I would like to edit my answer
} do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, author: user) }

  scenario "Unauthenticated user can't edit answers" do
    visit question_path(question)

    expect(page).not_to have_link "Edit"
  end

  describe "Authenticated user" do
    scenario "edits his own answer", js: true do
      sign_in(user)
      visit question_path(question)

      click_on "Edit"
      within ".answers" do
        fill_in "Body", with: "edited answer"
        click_on "Save"

        expect(page).to_not have_content answer.body
        expect(page).to have_content "edited answer"
        expect(page).to_not have_selector "textarea"
      end
    end

    scenario "edits his own answer with errors"
    scenario "tries to edit other user's answer"
  end
end

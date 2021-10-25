require "rails_helper"

feature "User can edit his answer", %q{
  In order to correct mistakes
  As an author of answer
  I would like to edit my answer
} do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }

  scenario "Unauthenticated user can't edit answers" do
    visit question_path(question)

    expect(page).not_to have_link "Edit"
  end

  describe "Authenticated user" do
    describe "is the author of answer" do
      given!(:answer) { create(:answer, question: question, author: user) }

      background do
        sign_in(user)

        visit question_path(question)
      end

      scenario "edits his own answer", js: true do
        click_on "Edit"
        within ".answers" do
          fill_in "Body", with: "edited answer"
          click_on "Save"

          expect(page).to_not have_content answer.body
          expect(page).to have_content "edited answer"
          expect(page).to_not have_selector "textarea"
        end

        expect(page).to have_content "Your answer successfully updated."
      end

      scenario "edits his own answer with errors", js: true do
        click_on "Edit"
        within ".answers" do
          fill_in "Body", with: ""
          click_on "Save"

          expect(page).to have_content answer.body
        end

        expect(page).to have_content "Body can't be blank"
      end
    end

    describe "is not the author of answer" do
      given!(:answer) { create(:answer, question: question) }

      scenario "tries to edit other user's answer" do
        sign_in(user)
        visit question_path(question)

        expect(page).to_not have_css("#edit-answer-#{answer.id}")
      end
    end
  end
end

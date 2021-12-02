require "rails_helper"

feature "User can add comments to question", %q{
  In order to provide additional info to my question
  As an questions author
  I would like to be able to add comments
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  describe "Authenticated user" do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario "User adds comment to question", js: true do
      within "#question-#{question.id}-comments" do
        click_on "Add comment"

        fill_in "Body", with: "Text text text"
        click_on "Add comment"

        expect(page).to have_css("h4", text: "Comments:")
        expect(page).to have_content "Text text text"
        expect(page).to have_content "Author: #{user.email}"
      end
    end

    scenario "User tries to add comment to question with invalid body", js: true do
      within "#question-#{question.id}-comments" do
        click_on "Add comment"
        fill_in "Body", with: ""
        click_button "Add comment"

        within ".comment-errors" do
          expect(page).to have_content "Body can't be blank"
        end
      end
    end
  end

  describe "Unauthenticated user" do
    scenario "can't add comment to answer" do
      visit question_path(question)

      within "#question-#{question.id}-comments" do
        expect(page).to_not have_link "Add comment"
      end
    end
  end
end

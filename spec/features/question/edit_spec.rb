require "rails_helper"

feature "User can edit his question", %q{
  In order to correct mistakes
  As an author of question
  I would like to edit my question
} do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }

  scenario "Unauthenticated user can't edit question" do
    visit question_path(question)

    expect(page).not_to have_link "Edit body"
    expect(page).not_to have_link "Edit title"
  end

  describe "Authenticated user" do
    describe "is the author of question" do
      background do
        sign_in(user)

        visit question_path(question)
      end

      scenario "edits his own question body", js: true do
        click_on "Edit body"
        within ".question" do
          fill_in "Body", with: "edited body"
          click_on "Save"

          expect(page).to_not have_content question.body
          expect(page).to have_content "edited body"
          expect(page).to_not have_selector "textarea"
        end

        expect(page).to have_content "Your question successfully updated."
      end

      scenario "edits his own question body with errors", js: true do
        click_on "Edit body"
        within ".question" do
          fill_in "Body", with: ""
          click_on "Save"

          expect(page).to have_content question.body
        end

        expect(page).to have_content "Body can't be blank"
      end

      scenario "edits his own question title", js: true do
        click_on "Edit title"
        within ".question" do
          fill_in "Title", with: "edited title"
          click_on "Save"

          expect(page).to_not have_content question.title
          expect(page).to have_content "edited title"
          expect(page).to_not have_selector "textarea"
        end

        expect(page).to have_content "Your question successfully updated."
      end

      scenario "edits his own question title with errors", js: true do
        click_on "Edit title"
        within ".question" do
          fill_in "Title", with: ""
          click_on "Save"

          expect(page).to have_content question.body
        end

        expect(page).to have_content "Title can't be blank"
      end

      scenario "edit question body with attached files", js: true do
        click_on "Edit body"

        within "#edit-question-body-#{question.id}" do
          attach_file "Files", ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
          click_on "Save"
        end

        within ".question-files-list" do
          expect(page).to have_link "rails_helper.rb"
          expect(page).to have_link "spec_helper.rb"
        end
      end
    end

    describe "is not the author of question" do
      given!(:question2) { create(:question) }

      scenario "tries to edit other user's question" do
        sign_in(user)
        visit question_path(question2)

        expect(page).to_not have_css("#edit-question-title-#{question2.id}")
      end
    end
  end
end

require "rails_helper"

feature "User can delete his attached files to question" do
  describe "Authenticated user" do
    describe "is the author of question" do
      given(:question) { create(:question, files: [fixture_file_upload("spec/spec_helper.rb")]) }
      given(:user) { question.author }

      background do
        sign_in(user)

        visit question_path(question)
      end

      scenario "can delete" do
        within ".question-files-list" do
          expect(page).to have_link "Remove"
          click_on "Remove"
          expect(page).to_not have_link "spec_helper.rb"
        end
      end
    end

    describe "is not the author of question" do
      given(:question) { create(:question, files: [fixture_file_upload("spec/spec_helper.rb")]) }
      given(:user) { create(:user) }

      background do
        sign_in(user)

        visit question_path(question)
      end

      scenario "can't delete" do
        within ".question-files-list" do
          expect(page).to_not have_link "Remove"
        end
      end
    end
  end

  describe "Unauthenticated user" do
    given(:question) { create(:question, files: [fixture_file_upload("spec/spec_helper.rb")]) }

    scenario "can't delete" do
      visit question_path(question)

      within ".question-files-list" do
        expect(page).to_not have_link "Remove"
      end
    end
  end
end

require "rails_helper"

feature "User can delete his answer" do
  describe "Authenticated user" do
    describe "is the author of answer" do
      given(:answer) { create(:answer) }
      given(:user) { answer.author }
      given(:question) { answer.question }

      background do
        sign_in(user)

        visit question_path(question)
      end

      scenario "can delete" do
        expect(page).to have_content "Delete answer"

        click_on "Delete answer"

        expect(page).to have_content "Your answer was successfully deleted."
      end
    end

    describe "is not the author of question" do
      given(:answer) { create(:answer) }
      given(:user) { create(:user) }
      given(:question) { answer.question }

      background do
        sign_in(user)

        visit question_path(question)
      end

      scenario "can't delete" do
        expect(page).not_to have_content "Delete answer"
      end
    end
  end

  describe "Unauthenticated user" do
    given(:answer) { create(:answer) }
    given(:question) { answer.question }

    background { visit question_path(question) }
    scenario "can't delete" do
      expect(page).not_to have_content "Delete answer"
    end
  end
end

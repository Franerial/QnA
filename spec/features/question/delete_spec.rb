require "rails_helper"

feature "User can delete his question" do
  describe "Authenticated user" do
    describe "is the author of question" do
      given(:user) { create(:user_with_questions, questions_count: 5) }

      background do
        sign_in(user)

        visit question_path(user.questions[2])
      end

      scenario "can delete" do
        expect(page).to have_content "Delete"
        click_on "Delete"

        expect(page).to have_content "Your question was successfully deleted."
      end
    end
    describe "is not the author of question" do
      given(:user) { create(:user) }
      given(:question) { create(:question) }

      background do
        sign_in(user)

        visit question_path(question)
      end

      scenario "can't delete" do
        expect(page).not_to have_content("Delete")
      end
    end
  end

  describe "Unauthenticated user" do
    given(:question) { create(:question) }

    scenario "can't delete" do
      visit question_path(question)
      expect(page).not_to have_content("Delete")
    end
  end
end

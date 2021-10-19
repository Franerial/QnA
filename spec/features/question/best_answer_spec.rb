require "rails_helper"

feature "User can mark answer as best", %q{
  The user can mark any answer to his question as "best"
  so that other users can make sure it is correct
} do
  describe "Authenticated user" do
    describe "is the author of question" do
      given(:question) { create(:question_with_answers, answers_count: 5) }
      given(:user) { question.author }

      background do
        sign_in(user)
        visit question_path(question)
        question.answers[2].update(body: "new body")
      end

      scenario "marks answer as best" do
        within ("#answer-li-#{question.answers[2].id}") do
          click_on("Mark answer as best")
        end

        expect(page).to have_css(".best-answer")

        within (".best-answer") do
          expect(page).to have_content question.answers[2].body
        end
      end
    end

    describe "is not the author of question" do
      given(:question) { create(:question_with_answers, answers_count: 5) }
      given(:user) { create(:user) }

      background do
        sign_in(user)
        visit question_path(question)
      end

      scenario "can't mark answer as best" do
        expect(page).not_to have_link "Mark answer as best"
      end
    end
  end

  describe "Unuthenticated user" do
    given(:question) { create(:question_with_answers, answers_count: 5) }

    background do
      visit question_path(question)
    end

    scenario "can't mark answer as best" do
      expect(page).not_to have_link "Mark answer as best"
    end
  end
end

require "rails_helper"

feature "User can delete his vote for question", %q{
  In order to change my opinion for the specific question
  As an authenticated user
  I would like to be able to delete my vote that question
} do
  describe "Authenticated user" do
    given(:user) { create(:user) }
    given!(:question) { create(:question) }
    given!(:vote) { create(:vote, votable: question, user: user, status: :dislike) }

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario "deletes his vote for question", js: true do
      within ".question-vote" do
        accept_confirm do
          click_on "Cansel vote"
        end

        expect(page).to have_content "You have just canselled your vote!"
        expect(page).to have_content "Current rating: 0"
      end
    end
  end

  describe "Unauthenticated user" do
    given(:question) { create(:question) }

    scenario "can't delete vote" do
      visit question_path(question)

      within ".question-vote" do
        expect(page).to_not have_css(".question-vote table")
      end
    end
  end
end

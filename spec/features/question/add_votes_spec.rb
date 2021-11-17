require "rails_helper"

feature "User can vote for question", %q{
  In order to express my opinion for the specific question
  As an authenticated user
  I would like to be able to vote for that question
} do
  describe "Authenticated user" do
    given(:user) { create(:user) }
    given!(:question) { create(:question) }
    given!(:question2) { create(:question) }
    given!(:vote) { create(:vote, votable: question2, user: user) }

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario "like question", js: true do
      within ".question-vote" do
        click_on "Like"
        expect(page).to have_content "You like this question!"
        expect(page).to_not have_link "Like"
        expect(page).to_not have_link "Dislike"

        expect(page).to have_content "Current rating: 1"
      end
    end

    scenario "dislike question", js: true do
      within ".question-vote" do
        click_on "Dislike"
        expect(page).to have_content "You dislike this question!"
        expect(page).to_not have_link "Like"
        expect(page).to_not have_link "Dislike"

        expect(page).to have_content "Current rating: -1"
      end
    end

    scenario "can't vote twice for question", js: true do
      visit question_path(question2)

      within ".question-vote" do
        expect(page).to have_link "Cansel vote"
        expect(page).to_not have_link "Dislike"
        expect(page).to_not have_link "Like"
      end
    end
  end

  describe "Unauthenticated user" do
    given!(:question) { create(:question) }

    scenario "can't vote" do
      visit question_path(question)

      within ".question-vote" do
        expect(page).to_not have_css(".question-vote table")
      end
    end
  end
end

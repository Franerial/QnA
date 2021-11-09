require "rails_helper"

feature "User can delete his attached links to question" do
  describe "Authenticated user" do
    given!(:question) { create(:question) }
    given!(:link) { create(:link, name: "link1", url: "https://www.google.ru/", linkable: question) }

    describe "is the author of question" do
      given!(:user) { question.author }

      background do
        sign_in(user)
        visit question_path(question)
      end

      scenario "can delete link" do
        within ".question-links" do
          expect(page).to have_link "Remove"
          click_on "Remove"
          expect(page).to_not have_link "link1"
        end
      end
    end

    describe "is not the author of question" do
      given!(:user) { create(:user) }

      background do
        sign_in(user)

        visit question_path(question)
      end

      scenario "can't delete" do
        within ".question-links" do
          expect(page).to_not have_link "Remove"
        end
      end
    end
  end

  describe "Unauthenticated user" do
    given!(:question) { create(:question) }
    given!(:link) { create(:link, name: "link1", url: "https://www.google.ru/", linkable: question) }

    background { visit question_path(question) }

    scenario "can't delete" do
      within ".question-links" do
        expect(page).to_not have_link "Remove"
      end
    end
  end
end

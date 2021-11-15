require "rails_helper"

feature "User can delete his attached links to answer" do
  describe "Authenticated user" do
    given!(:question) { create(:question) }
    given!(:answer) { create(:answer, question: question) }
    given!(:link) { create(:link, name: "link1", url: "https://www.google.ru/", linkable: answer) }

    describe "is the author of answer" do
      given!(:user) { answer.author }

      background do
        sign_in(user)
        visit question_path(question)
      end

      scenario "can delete link" do
        within "#answer-li-#{link.linkable.id}" do
          within ".answer-links" do
            expect(page).to have_link "Remove"
            click_on "Remove"
            expect(page).to_not have_link "link1"
          end
        end
      end
    end

    describe "is not the author of answer" do
      given!(:user) { create(:user) }

      background do
        sign_in(user)

        visit question_path(question)
      end

      scenario "can't delete" do
        within "#answer-li-#{link.linkable.id}" do
          within ".answer-links" do
            expect(page).to_not have_link "Remove"
          end
        end
      end
    end
  end

  describe "Unauthenticated user" do
    given!(:question) { create(:question) }
    given!(:answer) { create(:answer, question: question) }
    given!(:link) { create(:link, name: "link1", url: "https://www.google.ru/", linkable: answer) }

    background { visit question_path(question) }

    scenario "can't delete" do
      within "#answer-li-#{answer.id}" do
        within ".answer-links" do
          expect(page).to_not have_link "Remove"
        end
      end
    end
  end
end

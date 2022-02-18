require "sphinx_helper"

feature "User can search the answer" do
  given(:first_user) { create :user, email: "email1@gmail.com" }
  given(:second_user) { create :user, email: "email2@gmail.com" }
  given!(:first_answer) { create :answer, body: "Answer one", author: first_user }
  given!(:second_answer) { create :answer, body: "Answer two", author: second_user }

  before { visit search_path }

  describe "User select answer search checkbox" do
    before { find(:css, "#resources_answer").set(true) }

    scenario "searches the answer by body (which matches only first answer)", sphinx: true, js: true do
      ThinkingSphinx::Test.run do
        fill_in "Query", with: "one"
        click_on "Search"

        expect(page).to have_content "Results"
        expect(page).to have_content first_answer.body
        expect(page).to have_content first_answer.author.email
        expect(page).to have_link "View corresponding question"
        expect(find("ol").all("li").size).to eq 1

        expect(page).not_to have_content second_answer.body
        expect(page).not_to have_content second_answer.author.email
      end
    end

    scenario "searches the answer by body (which matches only second answer)", sphinx: true, js: true do
      ThinkingSphinx::Test.run do
        fill_in "Query", with: "two"
        click_on "Search"

        expect(page).to have_content "Results"
        expect(page).to have_content second_answer.body
        expect(page).to have_link "View corresponding question"
        expect(find("ol").all("li").size).to eq 1

        expect(page).not_to have_content first_answer.body
        expect(page).not_to have_content first_answer.author.email
      end
    end

    scenario "searches the answer by body (which matches both answers)", sphinx: true, js: true do
      ThinkingSphinx::Test.run do
        fill_in "Query", with: "Answer"
        click_on "Search"

        expect(page).to have_content "Results"
        expect(page).to have_content first_answer.body
        expect(page).to have_content second_answer.body
        expect(page).to have_content first_answer.author.email
        expect(page).to have_content second_answer.author.email
        expect(page).to have_link "View corresponding question"
        expect(find("ol").all("li").size).to eq 2
      end
    end

    scenario "searches the answer by body with invalid query", sphinx: true, js: true do
      ThinkingSphinx::Test.run do
        fill_in "Query", with: "something"
        click_on "Search"

        expect(page).not_to have_content "Results"
        expect(page).not_to have_content first_answer.body
        expect(page).not_to have_content second_answer.body
        expect(page).not_to have_css "ol"

        expect(page).to have_content "No entries found"
      end
    end

    context "when there are any resources with same query" do
      given!(:question) { create :question, body: "Question one" }

      scenario "doesn't find questions" do
        ThinkingSphinx::Test.run do
          fill_in "Query", with: "one"
          click_on "Search"

          expect(page).not_to have_content question.title
          expect(page).not_to have_content question.body
        end
      end
    end
  end

  scenario "searches the answer by body without Answer checkbox selected", sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      fill_in "Query", with: "body"
      click_on "Search"

      expect(page).to have_content "You should choose resources to search in"

      expect(page).not_to have_content first_answer.body
      expect(page).not_to have_content second_answer.body
      expect(page).not_to have_css "ol"
    end
  end
end

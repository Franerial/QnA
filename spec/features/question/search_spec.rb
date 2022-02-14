require "sphinx_helper"

feature "User can search the question" do
  given(:first_user) { create :user, email: "email1@gmail.com" }
  given(:second_user) { create :user, email: "email2@gmail.com" }
  given!(:first_question) { create :question, body: "Question one", title: "First question title", author: first_user }
  given!(:second_question) { create :question, body: "Question two", title: "Second question title", author: second_user }

  before { visit search_path }

  describe "User select question search checkbox" do
    before { find(:css, "#resources_question").set(true) }

    scenario "searches the question by body (which matches only first question)", sphinx: true, js: true do
      ThinkingSphinx::Test.run do
        fill_in "Query", with: "one"
        click_on "Search"

        expect(page).to have_content "Results"
        expect(page).to have_content first_question.body
        expect(page).to have_content first_question.title
        expect(page).to have_content first_question.author.email
        expect(find("ol").all("li").size).to eq 1

        expect(page).not_to have_content second_question.body
        expect(page).not_to have_content second_question.title
        expect(page).not_to have_content second_question.author.email
      end
    end

    scenario "searches the question by body (which matches only second question)", sphinx: true, js: true do
      ThinkingSphinx::Test.run do
        fill_in "Query", with: "two"
        click_on "Search"

        expect(page).to have_content "Results"
        expect(page).to have_content second_question.body
        expect(page).to have_content second_question.title
        expect(find("ol").all("li").size).to eq 1

        expect(page).not_to have_content first_question.body
        expect(page).not_to have_content first_question.title
        expect(page).not_to have_content first_question.author.email
      end
    end

    scenario "searches the question by body (which matches both questions)", sphinx: true, js: true do
      ThinkingSphinx::Test.run do
        fill_in "Query", with: "Question"
        click_on "Search"

        expect(page).to have_content "Results"
        expect(page).to have_content first_question.body
        expect(page).to have_content second_question.body
        expect(page).to have_content first_question.title
        expect(page).to have_content second_question.title
        expect(page).to have_content first_question.author.email
        expect(page).to have_content second_question.author.email

        expect(find("ol").all("li").size).to eq 2
      end
    end

    scenario "searches the question by title (which matches only first question)", sphinx: true, js: true do
      ThinkingSphinx::Test.run do
        fill_in "Query", with: "First question"
        click_on "Search"

        expect(page).to have_content "Results"
        expect(page).to have_content first_question.body
        expect(page).to have_content first_question.title
        expect(page).to have_content first_question.author.email
        expect(find("ol").all("li").size).to eq 1

        expect(page).not_to have_content second_question.body
        expect(page).not_to have_content second_question.title
        expect(page).not_to have_content second_question.author.email
      end
    end

    scenario "searches the question by body with invalid query", sphinx: true, js: true do
      ThinkingSphinx::Test.run do
        fill_in "Query", with: "something"
        click_on "Search"

        expect(page).not_to have_content "Results"
        expect(page).not_to have_content first_question.body
        expect(page).not_to have_content second_question.body
        expect(page).not_to have_css "ol"

        expect(page).to have_content "No entries found"
      end
    end

    context "when there are any resources with same query" do
      given!(:answer) { create :answer, body: "Answer one" }

      scenario "doesn't find questions" do
        ThinkingSphinx::Test.run do
          fill_in "Query", with: "one"
          click_on "Search"

          expect(page).not_to have_content answer.body
        end
      end
    end
  end

  scenario "searches the question by body without Question checkbox selected", sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      fill_in "Query", with: "body"
      click_on "Search"

      expect(page).to have_content "You should choose resources to search in"

      expect(page).not_to have_content first_question.body
      expect(page).not_to have_content second_question.body
      expect(page).not_to have_css "ol"
    end
  end
end

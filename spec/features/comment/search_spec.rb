require "sphinx_helper"

feature "User can search the comment" do
  given!(:question) { create :question, body: "Question one" }
  given(:first_user) { create :user, email: "email1@gmail.com" }
  given(:second_user) { create :user, email: "email2@gmail.com" }
  given!(:first_comment) { create :comment, body: "Comment one", user: first_user, commentable: question }
  given!(:second_comment) { create :comment, body: "Comment two", user: second_user, commentable: question }

  before { visit search_path }

  describe "User select comment search checkbox" do
    before { find(:css, "#resources_comment").set(true) }

    scenario "searches the comment by body (which matches only first comment)", sphinx: true, js: true do
      ThinkingSphinx::Test.run do
        fill_in "Query", with: "one"
        click_on "Search"

        expect(page).to have_content "Results"
        expect(page).to have_content first_comment.body
        expect(page).to have_content first_comment.user.email
        expect(page).to have_link "View corresponding question"
        expect(find("ol").all("li").size).to eq 1

        expect(page).not_to have_content second_comment.body
        expect(page).not_to have_content second_comment.user.email
      end
    end

    scenario "searches the comment by body (which matches only second comment)", sphinx: true, js: true do
      ThinkingSphinx::Test.run do
        fill_in "Query", with: "two"
        click_on "Search"

        expect(page).to have_content "Results"
        expect(page).to have_content second_comment.body
        expect(page).to have_link "View corresponding question"
        expect(find("ol").all("li").size).to eq 1

        expect(page).not_to have_content first_comment.body
        expect(page).not_to have_content first_comment.user.email
      end
    end

    scenario "searches the comment by body (which matches both comments)", sphinx: true, js: true do
      ThinkingSphinx::Test.run do
        fill_in "Query", with: "Comment"
        click_on "Search"

        expect(page).to have_content "Results"
        expect(page).to have_content first_comment.body
        expect(page).to have_content second_comment.body
        expect(page).to have_content first_comment.user.email
        expect(page).to have_content second_comment.user.email
        expect(page).to have_link "View corresponding question"
        expect(find("ol").all("li").size).to eq 2
      end
    end

    scenario "searches the comment by body with invalid query", sphinx: true, js: true do
      ThinkingSphinx::Test.run do
        fill_in "Query", with: "something"
        click_on "Search"

        expect(page).not_to have_content "Results"
        expect(page).not_to have_content first_comment.body
        expect(page).not_to have_content second_comment.body
        expect(page).not_to have_css "ol"

        expect(page).to have_content "No entries found"
      end
    end

    context "when there are any resources with same query" do
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

  scenario "searches the comment by body without Comment checkbox selected", sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      fill_in "Query", with: "body"
      click_on "Search"

      expect(page).to have_content "You should choose resources to search in"

      expect(page).not_to have_content first_comment.body
      expect(page).not_to have_content second_comment.body
      expect(page).not_to have_css "ol"
    end
  end
end

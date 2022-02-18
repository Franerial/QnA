require "sphinx_helper"

feature "User can search the user" do
  given!(:first_user) { create :user, email: "email1@gmail.com" }
  given!(:second_user) { create :user, email: "email2@gmail.com", admin: true }

  before { visit search_path }

  describe "User select user search checkbox" do
    before { find(:css, "#resources_user").set(true) }

    scenario "searches the user by email (which matches only first user)", sphinx: true, js: true do
      ThinkingSphinx::Test.run do
        fill_in "Query", with: "email1"
        click_on "Search"

        expect(page).to have_content "Results"
        expect(page).to have_content first_user.email
        expect(find("ol").all("li").size).to eq 1

        expect(page).not_to have_content second_user.email
      end
    end

    scenario "searches the user by email (which matches only second user)", sphinx: true, js: true do
      ThinkingSphinx::Test.run do
        fill_in "Query", with: "email2"
        click_on "Search"

        expect(page).to have_content "Results"
        expect(page).to have_content second_user.email
        expect(page).to have_content "Admin: true"
        expect(find("ol").all("li").size).to eq 1

        expect(page).not_to have_content first_user.email
      end
    end

    scenario "searches the user by email (which matches both users)", sphinx: true, js: true do
      ThinkingSphinx::Test.run do
        fill_in "Query", with: "@gmail.com"
        click_on "Search"

        expect(page).to have_content "Results"
        expect(page).to have_content first_user.email
        expect(page).to have_content second_user.email
        expect(find("ol").all("li").size).to eq 2
      end
    end

    scenario "searches the user by email with invalid query", sphinx: true, js: true do
      ThinkingSphinx::Test.run do
        fill_in "Query", with: "something"
        click_on "Search"

        expect(page).not_to have_content "Results"
        expect(page).not_to have_content first_user.email
        expect(page).not_to have_content second_user.email
        expect(page).not_to have_css "ol"

        expect(page).to have_content "No entries found"
      end
    end

    context "when there are any resources with same query" do
      given!(:question) { create :question, body: "Question gmail" }

      scenario "doesn't find questions" do
        ThinkingSphinx::Test.run do
          fill_in "Query", with: "gmail"
          click_on "Search"

          expect(page).not_to have_content question.title
          expect(page).not_to have_content question.body
        end
      end
    end
  end

  scenario "searches the user by email without User checkbox selected", sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      fill_in "Query", with: "body"
      click_on "Search"

      expect(page).to have_content "You should choose resources to search in"
      expect(page).not_to have_content first_user.email
      expect(page).not_to have_content second_user.email

      expect(page).not_to have_css "ol"
    end
  end
end

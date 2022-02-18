require "sphinx_helper"

feature "User can search any record", sphinx: true, js: true do
  given!(:user) { create :user, email: "someuser@email.com" }
  given!(:question) { create :question, title: "Question title", body: "Question body", author: user }
  given!(:answer) { create :answer, body: "Answer body", author: user }
  given!(:comment) { create :comment, body: "Comment body", user: user, commentable: answer }

  before { visit search_path }

  context "User selects question and answer search checkboxes" do
    before do
      find(:css, "#resources_question").set(true)
      find(:css, "#resources_answer").set(true)
    end

    scenario "and searches the questions and answers together" do
      ThinkingSphinx::Test.run do
        expect(page).not_to have_content "Results"
        expect(page).not_to have_content question.body
        expect(page).not_to have_content answer.body
        expect(page).not_to have_css "ol"

        fill_in "Query", with: "body"
        click_on "Search"

        expect(page).to have_content "Results"
        expect(page).to have_content question.body
        expect(page).to have_content answer.body
        expect(find("ol").all("li").size).to eq 2
      end
    end
  end

  context "User selects question, answer and comment search checkboxes" do
    before do
      find(:css, "#resources_question").set(true)
      find(:css, "#resources_answer").set(true)
      find(:css, "#resources_comment").set(true)
    end

    scenario "and searches the questions, answers and comments together" do
      ThinkingSphinx::Test.run do
        expect(page).not_to have_content "Results"
        expect(page).not_to have_content question.body
        expect(page).not_to have_content answer.body
        expect(page).not_to have_content comment.body
        expect(page).not_to have_css "ol"

        fill_in "Query", with: "body"
        click_on "Search"

        expect(page).to have_content "Results"
        expect(page).to have_content question.body
        expect(page).to have_content answer.body
        expect(page).to have_content comment.body
        expect(find("ol").all("li").size).to eq 3
      end
    end
  end

  context "User selects question, answer, comment and user search checkboxes" do
    before do
      find(:css, "#resources_question").set(true)
      find(:css, "#resources_answer").set(true)
      find(:css, "#resources_comment").set(true)
      find(:css, "#resources_user").set(true)
    end

    scenario "and searches the questions, answers, comments and users together" do
      ThinkingSphinx::Test.run do
        expect(page).not_to have_content "Results"
        expect(page).not_to have_content question.body
        expect(page).not_to have_content answer.body
        expect(page).not_to have_content comment.body
        expect(page).not_to have_content user.email
        expect(page).not_to have_css "ol"

        fill_in "Query", with: user.email
        click_on "Search"

        expect(page).to have_content "Results"
        expect(page).to have_content question.body
        expect(page).to have_content answer.body
        expect(page).to have_content comment.body
        expect(page).to have_content user.email
        expect(find("ol").all("li").size).to eq 4
      end
    end
  end
end

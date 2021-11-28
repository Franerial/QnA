require "rails_helper"

feature "User can create answer", %q{
  An authenticated user
  can create an answer to the corresponded question created by other users
  to help to solve their problems
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe "Authenticated user" do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario "Create answer", js: true do
      fill_in "Body", with: "Text text text"
      click_on "Create"

      expect(page).to have_content "Your answer successfully created."
      expect(page).to have_content "Text text text"
    end

    scenario "Create answer with errors", js: true do
      click_on "Create"
      expect(page).to have_content "Body can't be blank"
    end

    scenario "create answer with attached files", js: true do
      fill_in "Body", with: "Text text text"
      attach_file "File", ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on "Create"

      within ".answers" do
        expect(page).to have_link "rails_helper.rb"
        expect(page).to have_link "spec_helper.rb"
      end
    end
  end

  scenario "Unauthenticated user try to create answer" do
    visit question_path(question)
    click_on "Create"

    expect(page).to have_content "You need to sign in or sign up before continuing."
  end

  describe "multiple sessions", js: true do
    given(:another_user) { create(:user) }
    given!(:question_author) { question.author }

    given (:gem_url) { "https://rubygems.org/gems/cocoon" }
    given (:img_url) { "https://www.bl-school.com/blog/wp-content/uploads/2012/09/Koala.jpg" }

    scenario "answer appears on another user's page" do
      Capybara.using_session("user") do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session("guest") do
        visit question_path(question)
      end

      Capybara.using_session("another_user") do
        sign_in(another_user)
        visit question_path(question)
      end

      Capybara.using_session("question_author") do
        sign_in(question_author)
        visit question_path(question)
      end

      Capybara.using_session("user") do
        fill_in "Body", with: "Text text text"
        attach_file "File", ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        fill_in "Link name", with: "Cocoon gem"
        fill_in "Url", with: gem_url
        click_on "Add link"

        within all(".nested-fields").last do
          fill_in "Link name", with: "Koala"
          fill_in "Url", with: img_url
        end

        click_on "Create"

        expect(page).to have_content "Your answer successfully created."

        within "#answer-li-#{Answer.last.id}" do
          expect(page).to have_link "rails_helper.rb"
          expect(page).to have_link "spec_helper.rb"
          expect(page).to have_content "Text text text"
          expect(page).to have_link "Like"
          expect(page).to have_link "Dislike"
          expect(page).to_not have_link "Mark answer as best"
          expect(page).to have_link "Delete answer"
          expect(page).to have_link "Edit"
          expect(page).to have_link "Koala", href: img_url
          expect(page).to have_link "Cocoon gem", href: gem_url
        end
      end

      Capybara.using_session("question_author") do
        within "#answer-li-#{Answer.last.id}" do
          expect(page).to have_link "rails_helper.rb"
          expect(page).to have_link "spec_helper.rb"
          expect(page).to have_content "Text text text"
          expect(page).to have_link "Like"
          expect(page).to have_link "Dislike"
          expect(page).to have_link "Mark answer as best"
          expect(page).to_not have_link "Delete answer"
          expect(page).to_not have_link "Edit"
          expect(page).to have_link "Koala", href: img_url
          expect(page).to have_link "Cocoon gem", href: gem_url
        end
      end

      Capybara.using_session("another_user") do
        within "#answer-li-#{Answer.last.id}" do
          expect(page).to have_link "rails_helper.rb"
          expect(page).to have_link "spec_helper.rb"
          expect(page).to have_content "Text text text"
          expect(page).to have_link "Like"
          expect(page).to have_link "Dislike"
          expect(page).to_not have_link "Mark answer as best"
          expect(page).to_not have_link "Delete answer"
          expect(page).to_not have_link "Edit"
          expect(page).to have_link "Koala", href: img_url
          expect(page).to have_link "Cocoon gem", href: gem_url
        end
      end

      Capybara.using_session("guest") do
        within "#answer-li-#{Answer.last.id}" do
          expect(page).to have_link "rails_helper.rb"
          expect(page).to have_link "spec_helper.rb"
          expect(page).to have_content "Text text text"
          expect(page).to_not have_link "Like"
          expect(page).to_not have_link "Dislike"
          expect(page).to_not have_link "Mark answer as best"
          expect(page).to_not have_link "Delete answer"
          expect(page).to_not have_link "Edit"
          expect(page).to have_link "Koala", href: img_url
          expect(page).to have_link "Cocoon gem", href: gem_url
        end
      end
    end
  end
end

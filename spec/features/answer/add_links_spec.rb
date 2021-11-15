require "rails_helper"

feature "User can add links to answer", %q{
  In order to provide additional info to my answer
  As an questions author
  I would like to be able to add links
} do
  describe "When create answer" do
    given(:user) { create(:user) }
    given (:img_url) { "https://www.bl-school.com/blog/wp-content/uploads/2012/09/Koala.jpg" }
    given (:gem_url) { "https://rubygems.org/gems/cocoon" }
    given (:gist_url) { "https://gist.github.com/Franerial/283ff0a5fd804d5f28c35047b01e305c" }
    given(:question) { create(:question) }

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario "User adds links when create answer", js: true do
      fill_in "Body", with: "Text text text"
      fill_in "Link name", with: "Koala"
      fill_in "Url", with: img_url

      click_on "Add link"
      within all(".nested-fields").last do
        fill_in "Link name", with: "Cocoon gem"
        fill_in "Url", with: gem_url
      end

      click_on "Create"

      within ".answers" do
        expect(page).to have_link "Koala", href: img_url
        expect(page).to have_link "Cocoon gem", href: gem_url
      end
    end

    scenario "User adds links with errors when create answer", js: true do
      fill_in "Body", with: "Text text text"
      fill_in "Link name", with: "Koala"
      fill_in "Url", with: "123"

      click_on "Create"

      within ".answer-errors-create" do
        expect(page).to have_content "Links url is invalid"
      end
    end

    scenario "User adds link to gist when create answer", js: true do
      fill_in "Body", with: "Text text text"
      fill_in "Link name", with: "Gist link"
      fill_in "Url", with: gist_url

      click_on "Create"

      visit question_path(question)
      within ".gist" do
        expect(page).to have_content "How many messages will be printed to the console?"
      end
    end
  end

  describe "When edits answer" do
    given!(:user) { create(:user) }
    given (:img_url) { "https://www.bl-school.com/blog/wp-content/uploads/2012/09/Koala.jpg" }
    given (:gem_url) { "https://rubygems.org/gems/cocoon" }
    given (:gist_url) { "https://gist.github.com/Franerial/283ff0a5fd804d5f28c35047b01e305c" }
    given!(:question) { create(:question, author: user) }
    given!(:answer) { create(:answer, question: question, author: user) }

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario "User adds correct links when edits answer", js: true do
      within "#answer-li-#{answer.id}" do
        click_on "Edit"
        click_on "Add link"

        fill_in "Link name", with: "Koala"
        fill_in "Url", with: img_url

        click_on "Add link"

        within all(".nested-fields").last do
          fill_in "Link name", with: "Cocoon gem"
          fill_in "Url", with: gem_url
        end

        click_on "Save"
        within ".answer-links" do
          expect(page).to have_link "Koala", href: img_url
          expect(page).to have_link "Cocoon gem", href: gem_url
        end
      end
    end

    scenario "User adds links with errors when edits answer", js: true do
      within "#answer-li-#{answer.id}" do
        click_on "Edit"
        click_on "Add link"

        fill_in "Link name", with: "Koala"
        fill_in "Url", with: "123"

        click_on "Save"
      end

      within ".answer-errors" do
        expect(page).to have_content "Links url is invalid"
      end
    end

    scenario "User adds link to gist when edits answer", js: true do
      within "#answer-li-#{answer.id}" do
        click_on "Edit"
        click_on "Add link"

        fill_in "Link name", with: "Gist link"
        fill_in "Url", with: gist_url

        click_on "Save"
      end

      visit question_path(question)

      within("#answer-li-#{answer.id}") do
        within ".gist" do
          expect(page).to have_content "How many messages will be printed to the console?"
        end
      end
    end
  end
end

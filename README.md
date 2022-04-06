## Description:
##### This application is a question and answer website (simplified analogue of Stack Overflow). Main functionality includes:
* Users can ask questions and create corresponding answers (the author of resource has permission to update or to delete it)
* Users can leave comments for both resources
* There is a possibility to attach links and files to questions and answers
* The author of question can create an award, and the user, who gives the best answer to it (the author of question can choose the best answer), receives this badge. He can later view recieved badges on his profile page. If the best answer selected, it is displayed at the top of the list of answers
* There is a subcription system, when user can subscribe to question and later receive on email notifications about all question updates or when new answers appear
* Questions and answers have rating system, when users can vote up or vote against the resource. Current rating is displayed within each resource. It can be positive or negative. Users can vote only once per resource, but they can cansel vote and vote again
* Search system. User can visit special search page, choose resources where to search in (questions, answers, comments, users) and get all searching results
* User can sign in to system using github or vkontakte account 
* Application has own API for questions and answers CRUD operations; for getting users profiles list or one specific user profile
* All functionality is covered by unit and acceptance tests

## Used technologies and gems:
*  Rails 6
*  Devise
*  Pg (used PostgreSQL as the database for Active Record)
*  Slim for views
*  ActionCable (comments apear within WebSocket technology)
*  Sidekiq and configured ActionMailer (sending question updates and all new questions which appeared within last 24 hours)
*  Sphinx for searching 
*  Omniauth/omniauth-github/omniauth-vkontakte to sign in into system
*  Cocoon (to add nested forms when attaching links and files)
*  Cancancan for defining permissions 
*  Doorkeeper and active model serializers for defining API and authorization code flow
*  Google cloud storage for storing attached files
*  Javascript/Jquery/Json/Ajax for vote system
*  Rspec for unit tests
*  Capybara for acceptance tests

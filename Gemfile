source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.7.3"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem "rails", "~> 6.1.3"
# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"
# Use Puma as the app server
gem "puma", "~> 5.0"
# Use SCSS for stylesheets
gem "sass-rails", ">= 6"
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem "webpacker", "~> 5.0"
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem "turbolinks", "~> 5"
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder", "~> 2.7"
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
gem "devise", "~> 4.8", github: "heartcombo/devise"
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'
gem "jquery-rails", "~> 4.4"
# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", ">= 1.4.4", require: false

gem "slim-rails", "~> 3.3"

gem "google-cloud-storage", "~> 1.34", ">= 1.34.1"

gem "cocoon", "~> 1.2", ">= 1.2.15"

gem "gon", "~> 6.4"

gem "omniauth", "~> 2.0", ">= 2.0.4"

gem "omniauth-github", "~> 2.0"

gem "omniauth-vkontakte", "~> 1.7", ">= 1.7.1"

gem "omniauth-rails_csrf_protection", "~> 1.0"

gem "letter_opener", "~> 1.7"

gem "capybara-email", "~> 3.0", ">= 3.0.2"

gem "cancancan", "~> 3.3"

gem "doorkeeper", "~> 5.5", ">= 5.5.4"

gem "active_model_serializers", "~> 0.10.13"

gem "oj", "~> 3.13", ">= 3.13.11"

gem "sidekiq", "~> 6.4", ">= 6.4.1"

gem "sinatra", "~> 2.1", require: false

gem "whenever", "~> 1.0", require: false

gem "mysql2", "~> 0.5.3"

gem "thinking-sphinx", "~> 5.4"

gem "mini_racer", "~> 0.6.2"

gem "unicorn", "~> 6.1"

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  gem "rspec-rails", "~> 5.0", ">= 5.0.2"
  gem "factory_bot_rails", "~> 6.2"
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem "web-console", ">= 4.1.0"
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem "rack-mini-profiler", "~> 2.0"
  gem "listen", "~> 3.3"
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring"

  gem "capistrano", "~> 3.16", require: false
  gem "capistrano-bundler", "~> 2.0", ">= 2.0.1", require: false
  gem "capistrano-rails", "~> 1.6", ">= 1.6.1", require: false
  gem "capistrano-rvm", "~> 0.1.2", require: false
  gem "capistrano-passenger", "~> 0.2.1", require: false
  gem "capistrano-sidekiq", "~> 2.0", require: false
  gem "capistrano3-unicorn", "~> 0.2.1", require: false
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem "capybara", ">= 3.26"
  gem "selenium-webdriver"
  # Easy installation and use of web drivers to run system tests with browsers
  gem "webdrivers"
  gem "shoulda-matchers", "~> 5.0"
  gem "rails-controller-testing", "~> 1.0", ">= 1.0.5"
  gem "launchy", "~> 2.5"
  gem "database_cleaner", "~> 2.0", ">= 2.0.1"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]

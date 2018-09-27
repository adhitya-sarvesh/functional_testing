source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'haml', '~> 4.0.7' # For HAML templating
gem 'haml-rails', '~> 0.5'
gem 'hamlbars', '~> 2.0.1'
gem 'rails', '~> 5.1.0'
gem 'sprockets', '3.6.3'
gem 'puma', '~> 3.7' # Use Puma as the app server
gem 'therubyracer', '~> 0.12.0'
gem 'less-rails', '~> 2.5' # For LESS styling
gem 'bootstrap-sass', '~> 3.2.0' # Bootstrap
gem 'sass-rails', '~> 5.0' # Use SCSS for stylesheets
gem 'select2-rails'
gem 'uglifier', '>= 1.3.0' # Use Uglifier as compressor for JavaScript assets
gem 'jquery-rails', '~> 4.3' # This gem provides jQuery and the jQuery-ujs driver for the application.
gem 'jbuilder', '~> 2.5' # Build JSON APIs with ease
gem 'nested_form', '~> 0.3.2'
gem 'redcarpet', '~> 3.4.0'
gem 'pdfkit', '~> 0.8.2'
gem 'wkhtmltopdf-binary', '~> 0.12.3'
gem 'font-awesome-rails', '~> 4.7.0'
gem 'acts-as-taggable-on', '~> 5.0.0'
gem 'tagsinput-rails', '~> 1.3.5'

# Use Capistrano for deployment
gem 'rvm-capistrano', '1.5.6'
gem 'sidekiq', '5.0.0'
gem 'capistrano-sidekiq', '~> 0.10.0'

gem 'net-ldap', '~> 0.15.0'
gem 'urlcrypt', '~> 0.1.1', require: 'URLcrypt'

group :production do
  gem 'mysql2', '~> 0.4.4'
end

# Adds support for Capybara system testing and selenium driver
gem 'capybara', '~> 3.8'
gem 'poltergeist', '~> 1.18'
gem 'rspec-rails', '~> 3.5'

group :development, :test do
  gem 'byebug'
  gem 'selenium-webdriver'
  gem 'chromedriver-helper', '~> 1.0.0'
end

group :development, :test do
  gem 'sqlite3' # Use sqlite3 as the database for Active Record
  gem 'i18n-tasks', '~> 0.9.19'
end

group :development do
  gem 'web-console', '>= 3.3.0' # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring' # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'database_cleaner', '~> 1.3.0'
  gem 'factory_girl_rails', '~> 4.5.0' # Use factory in place of fixtures for testing
  gem 'simplecov', '~> 0.9.1', require: false
end

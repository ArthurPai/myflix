source 'https://rubygems.org'
ruby '2.1.1'

gem 'bootstrap-sass'
gem 'coffee-rails'
gem 'rails', '4.1.1'
gem 'haml-rails'
gem 'sass-rails'
gem 'uglifier'
gem 'jquery-rails'
gem 'bootstrap_form'

gem 'faker'
gem 'fabrication'

gem 'bcrypt'
gem 'figaro'

gem 'sidekiq'
gem 'sinatra', require: false
gem 'slim'

gem 'unicorn'
gem 'sentry-raven'
gem 'paratrooper'

gem 'carrierwave'
gem 'mini_magick'
gem 'fog'

gem 'stripe'

group :development do
  gem 'sqlite3'
  gem 'thin'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'guard-rspec'
  gem 'terminal-notifier-guard'
  gem 'guard-livereload'
  gem 'guard-pow', require: false
  gem 'letter_opener'
end

group :development, :test do
  gem 'rspec-rails', '2.99'
  gem 'capybara'
  gem 'launchy'
  gem 'pry'
  gem 'pry-remote'
  gem 'pry-nav'
end

group :test do
  gem 'shoulda-matchers'
  gem 'capybara-email', github: 'dockyard/capybara-email'
  gem 'database_cleaner', '1.2.0'
  gem 'vcr'
  gem 'webmock'
  gem 'selenium-webdriver'
end

group :production, :staging do
  gem 'pg'
  gem 'rails_12factor'
end


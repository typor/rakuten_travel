source 'https://rubygems.org'

gem 'rails', '4.2.1'
gem 'mysql2'

gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails'
gem 'jbuilder', '~> 2.0'
gem 'turbolinks'
gem 'sdoc', '~> 0.4.0', group: :doc

# bootstrap
gem 'bootstrap-sass'
gem 'bootstrap_form'
gem "select2-rails"
gem 'font-awesome-sass'
# pagination
gem 'kaminari'
# authenticate
gem 'sorcery'
gem 'bcrypt', '~> 3.1.7'
gem 'email_validator'
# sidekiq
gem 'hiredis'
gem 'redis', require:  ["redis", "redis/connection/hiredis"]
gem 'sidekiq'
gem 'whenever', require: false
gem 'sinatra'
# search
gem "ransack"
gem 'enumerize'
# utils
gem 'faraday'
gem 'settingslogic'
gem 'active_decorator'
gem 'tapp'

# server
gem 'puma'
gem 'dalli'

group :development do
  gem 'i18n-tasks'
  gem 'quiet_assets'
  gem 'rb-inotify', require: false
  gem 'rb-fsevent', require: false
  gem 'rb-fchange', require: false
  gem 'growl', require: false
  gem 'terminal-notifier-guard', require: false
  gem 'rb-notifu', require: false
  # capistrano
  gem 'capistrano'
  gem 'capistrano-rbenv'
  gem 'capistrano-bundler'
  gem 'capistrano3-puma'
  gem 'capistrano-rails'
  gem 'capistrano-sidekiq'
end

group :test do
  gem 'database_rewinder'
  gem 'shoulda-matchers'
  gem 'webmock', '1.15.2'
  gem 'vcr'
end

group :development, :test do
  gem 'guard-rspec'
  gem 'rspec'
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'byebug'
  gem 'web-console', '~> 2.0'
  gem 'spring'
end
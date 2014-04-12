source 'https://rubygems.org'

gem 'rails', '4.0.4'
gem 'sqlite3'
gem 'sass-rails', '~> 4.0.2'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
# bootstrap
gem 'bootstrap-sass', '~> 3.1.1'
gem 'bootstrap_form', git: 'git@github.com:bootstrap-ruby/rails-bootstrap-forms.git'
gem "select2-rails"
gem 'font-awesome-sass'
# pagination
gem 'kaminari'
# authenticate
gem 'sorcery', '~> 0.8.5'
gem 'bcrypt-ruby'
gem 'email_validator'
# sidekiq
gem 'hiredis'
gem 'redis', require:  ["redis", "redis/connection/hiredis"]
gem 'sidekiq'
gem 'sinatra', '>= 1.3.0', require: nil
# utils
gem 'faraday'
gem 'settingslogic'
gem 'active_decorator'
gem 'tapp'

group :development do
  gem 'thin'
  gem 'i18n-tasks', '~> 0.3.9'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'quiet_assets'
  gem 'rb-inotify', require: false
  gem 'rb-fsevent', require: false
  gem 'rb-fchange', require: false
  gem 'growl', require: false
  gem 'terminal-notifier-guard', require: false
  gem 'rb-notifu', require: false
end

group :test do
  gem 'database_rewinder'
  gem 'shoulda-matchers'
  gem 'webmock', '1.15.2'
  gem 'vcr'
end

group :development, :test do
  gem 'guard-rspec', '~> 4.2.8', require: false
  gem 'rspec', '~> 3.0.0.beta2'
  gem 'rspec-rails', '~> 3.0.0.beta'
  gem 'factory_girl_rails'
  gem 'capybara'
end

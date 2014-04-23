source 'https://rubygems.org'

gem 'rails', '4.0.4'
gem 'mysql2'

gem 'sass-rails', '~> 4.0.2'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'jbuilder'
# bootstrap
gem 'bootstrap-sass', '~> 3.1.1'
gem 'bootstrap_form', git: 'https://github.com/bootstrap-ruby/rails-bootstrap-forms.git'
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
gem 'whenever', require: false
gem 'sinatra', '>= 1.3.0', require: nil
# search
gem "ransack", git: "https://github.com/activerecord-hackery/ransack", branch: "rails-4"
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
  gem 'i18n-tasks', '~> 0.3.9'
  gem 'quiet_assets'
  gem 'rb-inotify', require: false
  gem 'rb-fsevent', require: false
  gem 'rb-fchange', require: false
  gem 'growl', require: false
  gem 'terminal-notifier-guard', require: false
  gem 'rb-notifu', require: false
  # capistrano
  gem 'capistrano', '~> 3.2.0'
  gem 'capistrano-rbenv', '~> 2.0'
  gem 'capistrano-bundler', '~> 1.1.2'
  gem 'capistrano3-puma'
  gem 'capistrano-rails', '~> 1.1'
  gem 'capistrano-sidekiq'
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
  gem 'rspec-rails', '~> 3.0.0.beta2'
  gem 'factory_girl_rails'
  gem 'capybara'
end
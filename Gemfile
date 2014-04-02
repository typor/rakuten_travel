source 'https://rubygems.org'

gem 'rails', '4.0.4'
gem 'sqlite3'
gem 'sass-rails', '~> 4.0.2'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'bootstrap-sass', '~> 3.1.1'
gem 'hiredis'
gem 'redis', require:  ["redis", "redis/connection/hiredis"]
gem 'faraday'
gem 'settingslogic'
gem 'active_decorator'
gem 'tapp'
gem 'thin'
gem 'bootstrap_form', git: 'git@github.com:bootstrap-ruby/rails-bootstrap-forms.git'
gem 'kaminari'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :development do
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
  gem 'webmock', '1.15.2'
  gem 'vcr'
end

group :development, :test do
  gem 'guard-rspec', '~> 4.2.8', require: false
  gem 'rspec', '~> 3.0.0.beta2'
  gem 'rspec-rails', '~> 3.0.0.beta'
  gem 'factory_girl_rails'
end

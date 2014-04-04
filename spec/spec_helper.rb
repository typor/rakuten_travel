# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'capybara/rails'
require 'capybara/rspec'
require 'vcr'
VCR.configure do |c|
  c.cassette_library_dir = File.expand_path(File.dirname(__FILE__) + '/fixtures/vcr')
  c.hook_into :webmock
  c.allow_http_connections_when_no_cassette = true
end

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

RSpec.configure do |config|
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = false
  config.order = "random"
  config.include FactoryGirl::Syntax::Methods
  config.include Capybara::DSL

  config.before :suite do
    begin
      DatabaseRewinder.clean_all
      FactoryGirl.lint
    rescue
      DatabaseRewinder.clean_all
    end
  end

  config.after :each do
    DatabaseRewinder.clean
  end
end

def login(user = nil)
  user ||= create(:user, password: 'password', password_confirmation: 'password')
  session[:user_id] = user.id
end
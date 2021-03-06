# config valid only for Capistrano 3.1
lock '3.2.0'

set :rbenv_type, :system
set :rbenv_ruby, '2.1.1'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all # default value

# repository
set :application, 'rakuten_travel'
set :repo_url, 'https://github.com/kengos/rakuten_travel.git'
set :scm, :git
set :git_shallow_clone, 1
set :deploy_via, :copy
set :linked_files, %w{config/database.yml config/application.yml config/sidekiq.yml config/initializers/secret_token.rb}
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# sidkiq
set :sidekiq_role, :web

namespace :deploy do
  after :publishing, :restart
end

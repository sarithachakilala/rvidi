require 'rvm/capistrano'
require 'bundler/capistrano'
require 'capistrano_colors'
require 'capistrano-deploytags'
require 'capistrano/ext/multistage'
require "delayed/recipes" # Required for delayed_jobs

set :rvm_ruby_string, 'ruby-1.9.3-p429@rvidi'
set :rvm_path, "$HOME/.rvm"
set :rvm_bin_path, "$HOME/.rvm/bin"
set :rvm_type, :user

set :stages, ["staging", "demo"]
set :default_stage, "staging"

set :use_sudo, false
set :keep_releases, 5
set :git_enable_submodules, 1

set :scm, 'git'
set :user, 'deploy'
set :repository, 'git@gitlab.qwinixtech.com:repositories/rails/rvidi.git'
set :base_path, '/u01/apps/qwinix'
set :normalize_asset_timestamps, false
set :default_shell, :bash

set :app_name, 'rvidi'
set :application, 'rvidi.qwinixtech.com'
set :shared_children, shared_children + %w{public/uploads}

before "deploy:assets:precompile", "deploy:copy_database_yml"
before "deploy:assets:precompile", "deploy:copy_media_server_yml"

after 'deploy', 'deploy:migrate'
after 'deploy', 'deploy:cleanup'
after 'deploy', 'delayed_job:restart' # To Restart delayed_job after deploying the code
## Necessary only to drop,create and reseed database. Not necessary other wise
# after 'deploy:update_code', 'deploy:kill_postgres_connections'

namespace :deploy do
  desc 'Tell Passenger to restart the app.'
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end

  desc "Symlink shared configs and folders on each release."
  task :copy_database_yml do
    run "mkdir -p #{shared_path}/config"
    run "cp -f #{release_path}/config/database.yml.example #{shared_path}/config/database.yml"
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "rm -f #{release_path}/config/database.yml.example"
  end

  task :copy_media_server_yml do
    run "ln -nfs #{shared_path}/config/media_server.yml.example #{release_path}/config/media_server.yml"
  end

  # To reset database connection, while deploying
  # desc 'kill pgsql users so database can be dropped'
  # task :kill_postgres_connections do
  #   run 'echo "SELECT pg_terminate_backend(procpid) FROM pg_stat_activity WHERE datname=\'mquiq_staging\';" | psql -U postgres'
  # end
end

namespace :delayed_job do
  desc "Restart the delayed_job process"
  task :restart, :roles => :app do
    run "cd #{current_path}; RAILS_ENV=#{stage} script/delayed_job restart"
  end
end



# Capistrano 3.0.x
task :query_interactive do
  on 'me@remote' do
    info capture("[[ $- == *i* ]] && echo 'Interactive' || echo 'Not interactive'")
  end
end
task :query_login do
  on 'me@remote' do
    info capture("shopt -q login_shell && echo 'Login shell' || echo 'Not login shell'")
  end
end


# This is the standard Phusion Passenger restart code. You will probably already
# have something like this (if you have already got Capistrano set up).
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, roles: :app, except: { no_release: true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end
server 'qwinixtech.com', :app, :web, :db, :primary => true

# RVM Settings
require 'rvm/capistrano'
set :rvm_ruby_string, 'ruby-1.9.3-p392@rvidi'
# Add RVM's lib directory to the load path.
$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
set :rvm_path, '/usr/local/rvm'
set :rvm_type, :system # Don't use system-wide RVM

set :deploy_via, :remote_cache
set :app_name, 'rvidi'
set :application, 'rvidi.qwinixtech.com'

set :deploy_to, "#{base_path}/#{app_name}"

set :branch, 'master'
#set :branch, 'video-quality'
set :port, 1022

set :rails_env, 'staging'
set :deploy_env, 'staging'

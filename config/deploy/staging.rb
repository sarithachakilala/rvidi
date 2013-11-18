server '162.243.94.70', :app, :web, :db, :primary => true

# RVM Settings
require 'rvm/capistrano'
# Add RVM's lib directory to the load path.
$:.unshift(File.expand_path('./lib', ENV['rvm_path']))

set :deploy_via, :remote_cache
set :app_name, 'rvidi'
set :application, 'rvidi.qwinixtech.com'

set :deploy_to, "#{base_path}/#{app_name}"

set :branch, 'master'
#set :branch, 'video-quality'
#set :port, 1122

set :rails_env, 'staging'
set :deploy_env, 'staging'

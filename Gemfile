source 'http://rubygems.org'

gem 'rails', '4.0.4'
gem 'jquery-rails'
gem 'multi_json', '1.7.2'                            # To provide easy switching between different JSON backends. Warnings with latest Gem Version 1.7.3
gem 'delayed_job_active_record'                      # For executing delayed_jobs
gem 'psych'                                          # Libyaml Wrapper for Ruby
gem 'configatron'                                    # to add configuration values as environment specific and as default values as well.
gem 'omniauth-facebook', '1.4.0'                     # For Integrating Facebook
gem 'omniauth-twitter'                               # For Integrating Twitter
gem "recaptcha", :require => "recaptcha/rails"
gem 'rest-client'                                    # Simple HTTP and REST client for Ruby, inspired by the Sinatra microframework style of specifying actions: get, put, post, delete.
gem "rmagick", :platforms => :ruby
gem "carrierwave"
# To add file uploads to the application
gem 'actionview-encoded_mail_to'
gem 'inherited_resources'
## Pagination
gem 'kaminari'
gem 'bootstrap-kaminari-views'

gem 'koala'
# koala dependencies
gem 'twitter'
# Commenting 'linkedin' coz of error in deploying
# gem 'linkedin', :git => "git://github.com/pengwynn/linkedin.git"
gem 'social-share-button'
gem 'streamio-ffmpeg'

# DB Related
gem 'pg'
gem "bcrypt-ruby", :require => "bcrypt"              # To encrpty the user password

#video libs
gem 'carrierwave-video'
gem 'carrierwave-video-thumbnailer'
gem 'net-ssh'

# To upgrade to RAILS4
gem 'protected_attributes'

# Gems used only for assets and not required
# in production environments by default.
group :assets do

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # Fixed the vesion of therubyracer because of Segmentation Fault + Ruby 1.9.3p392
  gem 'therubyracer',  '0.11.3', :platforms => :ruby # Necessary, to Provide Javascrtpt Runtime.
  gem 'uglifier', '>= 1.0.3'
  gem 'thin'                              # To avoid content-type warning messages caused by webrick, except in production.
  gem 'coffee-rails'
  gem 'sass-rails'

end

group :development, :test do
  gem 'pry'
  gem 'pry-doc'
  gem 'pry-rails'
  gem 'pry-debugger'
  gem 'railroady'
  gem 'turn', :require => false                      # Pretty printed test output
  gem 'spork', '~> 0.9.2'                            # for fast running of tests
  gem 'faker'                                        # for building fake data
  gem 'factory_girl_rails'                           # for generating test data
  gem 'rspec'                                        # unit test framework
  gem 'rspec-rails'                                  # rspec only for rails
  gem 'shoulda-matchers'                             # making tests easy
  gem 'email_spec', '~> 1.2.1'                       # for testing emails in rspec and cucumber
  gem 'database_cleaner'                             # for cleaning the database between test suites
  gem 'cucumber-rails', '~>1.3.0', :require => false # integration testing
  gem 'webrat'                                       # writing acceptance tests
  gem 'minitest', '4.7.4'                            # dependency for webrat or capybara; not sure
  gem 'headless', '>= 0.1.0'                         # capybara webkit driver
  gem 'launchy'                                      # capybara dependency
  gem 'simplecov', :require => false                 # for providing test coverage statistics
  gem 'rb-readline', '~> 0.4.2'
  gem 'nokogiri'
  # gem 'capybara'                        # integration testing tool for rack based web applications; simulates user interaction with web app
  # gem 'capybara-webkit', :git => "git://github.com/thoughtbot/capybara-webkit.git" # Capybara driver for headless WebKit so you can test Javascript web apps
end

group :development do
  gem 'better_errors'                                # To debug errors very effectively and handles exceptions
  gem 'binding_of_caller'                            # To show all the local and instance variables
  gem 'quiet_assets'                                 # To Avoid Asset Pipeline Log in Development

  # To Deploy the Application using Capistrano
  gem 'capistrano'
  gem 'rvm-capistrano'
  gem 'capistrano-deepmodules'
  gem 'capistrano_colors'
  gem 'capistrano-ext'
  gem 'capistrano-deploytags'
end

group :test do
  gem "shoulda-callback-matchers"
end


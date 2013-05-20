source 'https://rubygems.org'

gem 'rails', '3.2.13'
gem 'jquery-rails'
gem 'multi_json', '1.7.2'                            # To provide easy switching between different JSON backends. Warnings with latest Gem Version 1.7.3
gem 'delayed_job_active_record', '0.3.3'             # For executing delayed_jobs
gem 'psych'                                          # Libyaml Wrapper for Ruby
gem 'configatron'                                    # to add configuration values as environment specific and as default values as well.
gem 'omniauth-facebook', '1.4.0'                     # For Integrating Facebook
gem 'omniauth-twitter'                               # For Integrating Twitter
gem "recaptcha", :require => "recaptcha/rails"

# gem 'socialshare'

# Social share dependencies
gem 'twitter'
gem 'linkedin', :git => "git://github.com/pengwynn/linkedin.git"
gem 'koala'


# DB Related
gem 'pg'
gem "bcrypt-ruby", :require => "bcrypt"              # To encrpty the user password

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  
  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # Fixed the vesion of therubyracer because of Segmentation Fault + Ruby 1.9.3p392
  gem 'therubyracer',  '0.11.3', :platforms => :ruby # Necessary, to Provide Javascrtpt Runtime.
  gem 'uglifier', '>= 1.0.3'
  gem 'thin'                              # To avoid content-type warning messages caused by webrick, except in production.
end

gem 'jquery-rails'
gem 'delayed_job_active_record', '0.3.3'             # For executing delayed_jobs

group :development, :test do
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
  gem 'capybara-webkit'                              # Capybara driver for headless WebKit so you can test Javascript web apps
  gem 'webrat'                                       # writing acceptance tests
  gem 'minitest'                                     # dependency for webrat or capybara; not sure 
  gem 'capybara', '~> 1.1.2'                         # integration testing tool for rack based web applications; simulates user interaction with web app
  gem 'headless', '>= 0.1.0'                         # capybara webkit driver
  gem 'launchy'                                      # capybara dependency
  gem 'simplecov', :require => false                 # for providing test coverage statistics
end

group :development do
  gem 'better_errors'                                # To debug errors very effectively and handles exceptions
  gem 'binding_of_caller'                            # To show all the local and instance variables
  gem 'quiet_assets'                                 # To Avoid Asset Pipeline Log in Development

  # To Deploy the Application using Capistrano
  gem 'rvm-capistrano'
  gem 'capistrano'
  gem 'capistrano-deepmodules'
  gem 'capistrano_colors'
  gem 'capistrano-ext'
  gem 'capistrano-deploytags'  
end

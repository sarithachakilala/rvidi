source 'https://rubygems.org'

gem 'rails', '3.2.13'
# Gems used only for assets and not required
# in production environments by default.
group :assets do
  # gem 'sass-rails',   '~> 3.2.3' --> Not using as of now.
  # gem 'coffee-rails', '~> 3.2.1' --> Not using as of now.

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # Fixed the vesion of therubyracer because of Segmentation Fault + Ruby 1.9.3p392
  gem 'therubyracer',  '0.11.3', :platforms => :ruby # Necessary, to Provide Javascrtpt Runtime.

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

# DB Related
gem 'bson_ext'
gem 'mongo'
gem 'mongoid'
gem 'devise', '2.2.3'

# which debugs errors very effectively and handles exceptions
gem 'better_errors' , :group => [:development]
#  shows all the local and instance variables
gem 'binding_of_caller', :group => [:development] 

group :development, :test do
  gem 'turn', :require => false                      # Pretty printed test output
  gem 'spork', '~> 0.9.2'                            # for fast running of tests
  gem 'faker'                                        # for building fake data
  gem 'factory_girl_rails'                           # for generating test data
  gem 'rspec'                                        # unit test framework
  gem 'rspec-rails'                                  # rspec only for rails
  gem 'shoulda-matchers'                             # helps to test relationships easily for rspec
  gem 'email_spec', '~> 1.2.1'                       # for testing emails in rspec and cucumber
  gem 'database_cleaner'                             # for cleaning the database between test suites
  gem 'cucumber-rails', '~>1.3.0', :require => false # integration testing
  gem 'webrat'                                       # writing acceptance tests
  gem 'minitest'                                     # dependency for webrat or capybara; not sure 
  gem 'capybara', '~> 1.1.2'                         # integration testing tool for rack based web applications; simulates user interaction with web app
  gem 'headless', '>= 0.1.0'                         # capybara webkit driver
  gem 'launchy'                                      # capybara dependency
  gem 'simplecov', :require => false                 # for providing test coverage statistics
end

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'

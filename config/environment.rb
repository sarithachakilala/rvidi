# Load the rails application
require File.expand_path('../application', __FILE__)

# I was using ruby 1.9.2 and changed and an UTF_8 problem arised these lines solved the problems
# again changed to 1.9.3 which solved the problem without this requirement
# if RUBY_VERSION =~ /1.9/
#   Encoding.default_external = Encoding::UTF_8
#   Encoding.default_internal = Encoding::UTF_8
# end

# Initialize the rails application
Rvidi::Application.initialize!

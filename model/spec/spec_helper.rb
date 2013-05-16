# require 'curator'
require 'mongoid'

# Curator.configure(:mongo) do |config|
#   config.environment = "test"
#   config.database = "container_shipping"
#   config.mongo_config_file = File.expand_path(File.dirname(__FILE__) + "/../../config/mongo.yml")
# end

# TODO Move this to a better place once I get mongoid working
#
# From http://mongoid.org/en/mongoid/docs/installation.html#configuration[Mongoid configuration docs]:
#
# When Mongoid loads its configuration, it chooses the environment to used based on the following order:
# 
# * Rails.env if using Rails.
# * Sinatra::Base.environment if using Sinatra.
# * RACK_ENV environment variable.
# * MONGOID_ENV environment variable.
#
# If you are not using any rack based application and want to override the environment programatically, you can pass a second paramter to load! and Mongoid will use that.

puts "got here..."
Mongoid.load!("#{File.dirname(__FILE__)}/../config/mongoid.yml", :development)

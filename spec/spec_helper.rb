# require 'curator'
require 'mongoid'

# Curator.configure(:mongo) do |config|
#   config.environment = "test"
#   config.database = "container_shipping"
#   config.mongo_config_file = File.expand_path(File.dirname(__FILE__) + "/../../config/mongo.yml")
# end

    # TODO Move this to a better place once I get mongoid working
Mongoid.load!("#{File.dirname(__FILE__)}/../config/mongoid.yml")

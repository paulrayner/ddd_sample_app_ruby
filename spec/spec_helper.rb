require 'mongoid'

# TODO Move this to a better place once I get mongoid working
Mongoid.load!("#{File.dirname(__FILE__)}/../config/mongoid.yml")

# TODO Do something cleaner than this for data setup/teardown
CargoDocument.delete_all
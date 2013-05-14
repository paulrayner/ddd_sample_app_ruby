Curator.configure(:mongo) do |config|
  # config.environment = Rails.env
  config.database = "container_shipping"
  config.mongo_config_file = File.expand_path(File.dirname(__FILE__) + "/../../config/mongo.yml")
end

RSpec.configure do |config|
  config.before(:suite) do
    Curator.data_store.remove_all_keys
  end

  config.after(:each) do
    Curator.data_store.reset!
  end
end
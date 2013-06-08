require 'mongoid'

class LocationRepository

  def initialize
    # TODO Move this somewhere (base class?) for all Mongoid-based repositories
    Mongoid.load!("#{File.dirname(__FILE__)}/../../../config/mongoid.yml", :development)
  end

  def store(location)
    location_document = LocationDocumentAdaptor.new.transform_to_mongoid_document(location)
    location_document.save
  end

  def find(unlocode)
    location_document = LocationDocument.find_by(location_code: unlocode.code)
    LocationDocumentAdaptor.new.transform_to_location(location_document)
  end

  def find_all(unlocode)
    handling_event_history = Array.new()
    LocationDocument.where(tracking_id: tracking_id.id).each do | location_document |
      handling_event_history << LocationDocumentAdaptor.new.transform_to_handling_event(location_document)
    end
    handling_event_history
  end

  # TODO Do something cleaner than this for data setup/teardown - yikes!
  def nuke_all_locations
    LocationDocument.delete_all
  end
end

class LocationDocument
  include Mongoid::Document

  field :location_code, type: String
  field :location_name, type: String
end

class LocationDocumentAdaptor
  def transform_to_mongoid_document(location)
    location_document = LocationDocument.new(
      location_code:     location.unlocode.code,
      location_name:     location.name
    )
    location_document
  end

  def transform_to_location(location_document)
    Location.new(UnLocode.new(location_document[:location_code]), location_document[:location_name])
  end
end
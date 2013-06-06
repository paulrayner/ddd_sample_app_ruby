require 'mongoid'

class HandlingEventRepository

  def initialize
    # TODO Move this somewhere (base class?) for all Mongoid-based repositories
    Mongoid.load!("#{File.dirname(__FILE__)}/../../../config/mongoid.yml", :development)
  end

  def store(handling_event)
    handling_event_document = HandlingEventDocumentAdaptor.new.transform_to_mongoid_document(handling_event)
    handling_event_document.save
  end

  def lookup_handling_history_of_cargo(tracking_id)
    handling_event_history = Array.new()
    HandlingEventDocument.where(tracking_id: tracking_id.id).each do | handling_event_document |
      handling_event_history << HandlingEventDocumentAdaptor.new.transform_to_handling_event(handling_event_document)
    end
    handling_event_history
  end

  # TODO Do something cleaner than this for data setup/teardown - yikes!
  def nuke_all_handling_events
    HandlingEventDocument.delete_all
  end
end

class HandlingEventDocument
  include Mongoid::Document

  field :tracking_id, type: String
  field :event_type, type: String
  field :location_code, type: String
  field :location_name, type: String
  field :registration_date, type: DateTime
  field :completion_date, type: DateTime
end

class HandlingEventDocumentAdaptor
  def transform_to_mongoid_document(handling_event)
    handling_event_document = HandlingEventDocument.new(
      tracking_id:       handling_event.tracking_id.id,
      event_type:        handling_event.event_type,
      location_code:     handling_event.location.unlocode.code,
      location_name:     handling_event.location.name,
      registration_date: handling_event.registration_date,
      completion_date:   handling_event.completion_date
    )
    handling_event_document
  end

  def transform_to_handling_event(handling_event_document)
    tracking_id = handling_event_document[:tracking_id]
    event_type = handling_event_document[:event_type]
    location = Location.new(UnLocode.new(handling_event_document[:location_code]), handling_event_document[:location_name])
    registration_date = handling_event_document[:registration_date]
    completion_date = handling_event_document[:completion_date]
    HandlingEvent.new(event_type, location, registration_date, completion_date, tracking_id)
  end
end
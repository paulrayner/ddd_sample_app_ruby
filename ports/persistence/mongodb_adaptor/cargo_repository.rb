require 'mongoid'

class CargoRepository

  def initialize
    # TODO Move this somewhere (base class?) for all Mongoid-based repositories
    Mongoid.load!("#{File.dirname(__FILE__)}/../../../config/mongoid.yml", :development)
  end

  def store(cargo)
    cargo_document = CargoDocumentAdaptor.new.transform_to_mongoid_document(cargo)
    cargo_document.save
  end

  def find_by_tracking_id(tracking_id)
    cargo_doc = CargoDocument.find_by(tracking_id: tracking_id.id)
    CargoDocumentAdaptor.new.transform_to_cargo(cargo_doc)
  end

  # TODO Do something cleaner than this for data setup/teardown - yikes!
  def nuke_all_cargo
    CargoDocument.delete_all
  end
end

class CargoDocument
  include Mongoid::Document

  field :tracking_id, type: String
  field :origin_code, type: String
  field :destination_code, type: String
  field :origin_name, type: String
  field :destination_name, type: String
  field :arrival_deadline, type: DateTime
  #-----
  # Decide whether we need to persist these, since they are derived from legs. They might
  # make reporting from MongoDB easier...treating them like a cache of useful values...
  field :initial_departure_location_code, type: String
  field :initial_departure_location_name, type: String
  field :final_arrival_location_code, type: String
  field :final_arrival_location_name, type: String
  field :final_arrival_date, type: DateTime
  #-----
  embeds_many :leg_documents

  # TODO Figure out how best to handle the tracking ID value object - should be indexed I suppose
  # index({ tracking_id: 1 }, { unique: true, name: "tracking_id" })
end

class LegDocument
  include Mongoid::Document

  # TODO Decide whether Location should be its own document. It's kinda a pain to keep writing both code
  # and name for each location, plus prone to error.
  field :voyage, type: String
  field :load_location_code, type: String
  field :load_location_name, type: String
  field :unload_location_code, type: String
  field :unload_location_name, type: String
  field :load_date, type: DateTime
  field :unload_date, type: DateTime

  embedded_in :cargo_document 
end

class CargoDocumentAdaptor
  def transform_to_mongoid_document(cargo)
    cargo_document = CargoDocument.new(
      tracking_id:       cargo.tracking_id.id,
      origin_code:       cargo.route_specification.origin.unlocode.code,
      origin_name:       cargo.route_specification.origin.name,
      destination_code:  cargo.route_specification.destination.unlocode.code,
      destination_name:  cargo.route_specification.destination.name,
      arrival_deadline:  cargo.route_specification.arrival_deadline
    )
    cargo_document.leg_documents.concat(transform_to_leg_documents(cargo.itinerary.legs))
    cargo_document
  end

  def transform_to_cargo(cargo_document)
    legs = transform_to_legs(cargo_document.leg_documents)
    itinerary = Itinerary.new(legs)
    origin = Location.new(UnLocode.new(cargo_document[:origin_code]), cargo_document[:origin_name])
    destination = Location.new(UnLocode.new(cargo_document[:destination_code]), cargo_document[:destination_name])
    route_spec = RouteSpecification.new(origin, destination, cargo_document[:arrival_deadline])
    tracking_id = TrackingId.new(cargo_document[:tracking_id])
    
    cargo = Cargo.new(tracking_id, route_spec)
    cargo.assign_to_route(itinerary)

    cargo
  end

  def transform_to_leg_documents(legs)
    leg_documents = Array.new
    legs.each do |leg|
      leg_document = LegDocument.new(
        voyage:               leg.voyage,
        load_location_code:   leg.load_location.unlocode.code,
        load_location_name:   leg.load_location.name,
        unload_location_code: leg.unload_location.unlocode.code,
        unload_location_name: leg.unload_location.name,
        load_date:            leg.load_date,
        unload_date:          leg.unload_date
      )
      leg_documents << leg_document
    end
    leg_documents
  end

  def transform_to_legs(leg_documents)
    legs = Array.new
    leg_documents.each do |leg_document|
      load_location   = Location.new(leg_document[:load_location_code], leg_document[:load_location_name])
      unload_location = Location.new(leg_document[:unload_location_code], leg_document[:unload_location_name])
      legs << Leg.new(
                      leg_document[:voyage],
                      load_location,
                      leg_document[:load_date],
                      unload_location,
                      leg_document[:unload_date]
                      )
    end
    legs
  end
end


# TODO Decide whether to break out value objects (Delivery, RouteSpecification
#      and Itinerary) into embedded documents, such as:
#
# In CargoDocument:
#
# embeds_one :route_specification_document

# class RouteSpecificationDocument
#   include Mongoid::Document
#   field :arrival_deadline, type: Date
# ...
#   embedded_in :cargo_documents
# end
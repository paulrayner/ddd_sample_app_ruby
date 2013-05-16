require 'mongoid'
require 'pp'

class CargoRepository
  def save(cargo)
    cargo_document = CargoDocumentAdaptor.new.transform_to_mongoid_document(cargo)
    cargo_document.save
  end

  def find_by_tracking_id(tracking_id)
    cargo_doc = CargoDocument.find_by(tracking_id: tracking_id.id)
    pp cargo_doc
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
  field :arrival_deadline, type: Date
end

class CargoDocumentAdaptor
  def transform_to_mongoid_document(cargo)
    CargoDocument.new(
      tracking_id:       cargo.tracking_id.id,
      origin_code:       cargo.route_specification.origin.unlocode.code,
      origin_name:       cargo.route_specification.origin.name,
      destination_code:  cargo.route_specification.destination.unlocode.code,
      destination_name:  cargo.route_specification.destination.name,
      arrival_deadline:  cargo.route_specification.arrival_deadline
    )
  end

  def transform_to_cargo(cargo_doc)
    origin = Location.new(UnLocode.new(cargo_doc[:origin_code]), cargo_doc[:origin_name])
    destination = Location.new(UnLocode.new(cargo_doc[:destination_code]), cargo_doc[:destination_name])
    route_spec = RouteSpecification.new(origin, destination, cargo_doc[:arrival_deadline])
    tracking_id = TrackingId.new(cargo_doc[:tracking_id])
    
    Cargo.new(tracking_id, route_spec)
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
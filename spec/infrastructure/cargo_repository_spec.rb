require 'spec_helper'
require 'rspec'
require 'date'
require 'pp'
require "#{File.dirname(__FILE__)}/../../ports/persistence/mongodb_adaptor/cargo_repository"

require "#{File.dirname(__FILE__)}/../../model/cargo/cargo"
require "#{File.dirname(__FILE__)}/../../model/cargo/leg"
require "#{File.dirname(__FILE__)}/../../model/cargo/itinerary"
require "#{File.dirname(__FILE__)}/../../model/cargo/tracking_id"
require "#{File.dirname(__FILE__)}/../../model/cargo/route_specification"
require "#{File.dirname(__FILE__)}/../../model/location/location"
require "#{File.dirname(__FILE__)}/../../model/location/unlocode"

describe "CargoRepository" do
  it "Cargo aggregate can be persisted" do
    cargo_repository = CargoRepository.new

    # TODO Replace this quick-and-dirty data teardown...
    cargo_repository.nuke_all_cargo

    origin = Location.new(UnLocode.new('HKG'), 'Hong Kong')
    destination = Location.new(UnLocode.new('DAL'), 'Dallas')
    arrival_deadline = Date.new(2013, 7, 1)

    route_spec = RouteSpecification.new(origin, destination, arrival_deadline)
    tracking_id = TrackingId.new('cargo_1234')
    port = Location.new(UnLocode.new('LGB'), 'Long Beach')
    legs = Array.new
    legs << Leg.new('Voyage ABC', origin, Date.new(2013, 6, 14), port, Date.new(2013, 6, 19))
    legs << Leg.new('Voyage DEF', port, Date.new(2013, 6, 21), destination, Date.new(2013, 6, 24))
    itinerary = Itinerary.new(legs)
    cargo = Cargo.new(tracking_id, route_spec)
    cargo.assign_to_route(itinerary)

    cargo_repository.save(cargo)

    found_cargo = cargo_repository.find_by_tracking_id(tracking_id)
    found_cargo.route_specification == route_spec
    found_cargo.tracking_id == tracking_id
    found_cargo.itinerary == itinerary
    found_cargo.itinerary.legs[0].load_location.name == itinerary.legs[0].load_location.name
    found_cargo.itinerary.legs[1].load_location.name == itinerary.legs[1].load_location.name

    # TODO Make the following checks redundant with equality on RouteSpecification
    found_cargo.route_specification.origin.unlocode.code == 'HKG'
    found_cargo.route_specification.origin.name == 'Hong Kong'
    found_cargo.route_specification.destination.unlocode.code == 'DAL'
    found_cargo.route_specification.destination.name == 'Dallas'
    found_cargo.route_specification.arrival_deadline == arrival_deadline
  end
end
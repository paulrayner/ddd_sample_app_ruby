require 'spec_helper'
require 'rspec'
require 'date'
require "#{File.dirname(__FILE__)}/../ports/persistence/mongodb_adaptor/cargo_repository"

require "#{File.dirname(__FILE__)}/../model/cargo/cargo"
require "#{File.dirname(__FILE__)}/../model/cargo/leg"
require "#{File.dirname(__FILE__)}/../model/cargo/itinerary"
require "#{File.dirname(__FILE__)}/../model/cargo/tracking_id"
require "#{File.dirname(__FILE__)}/../model/cargo/route_specification"

require "#{File.dirname(__FILE__)}/../model/location/location"
require "#{File.dirname(__FILE__)}/../model/location/unlocode"

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
    cargo = Cargo.new(tracking_id, route_spec)

    cargo_repository.save(cargo)

    found_cargo = cargo_repository.find_by_tracking_id(tracking_id)
    found_cargo.route_specification == route_spec
    found_cargo.tracking_id == tracking_id

    # TODO Make the following checks redundant with equality on RouteSpecification
    found_cargo.route_specification.origin.unlocode.code == 'HKG'
    found_cargo.route_specification.origin.name == 'Hong Kong'
    found_cargo.route_specification.destination.unlocode.code == 'DAL'
    found_cargo.route_specification.destination.name == 'Dallas'
    found_cargo.route_specification.arrival_deadline == arrival_deadline
  end
end
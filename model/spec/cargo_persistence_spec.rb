require 'rspec'
require 'date'
require "#{File.dirname(__FILE__)}/../cargo/cargo"
require "#{File.dirname(__FILE__)}/../cargo/leg"
require "#{File.dirname(__FILE__)}/../cargo/itinerary"
require "#{File.dirname(__FILE__)}/../cargo/tracking_id"
require "#{File.dirname(__FILE__)}/../cargo/route_specification"
require "#{File.dirname(__FILE__)}/../cargo/cargo_repository"

require "#{File.dirname(__FILE__)}/../location/location"
require "#{File.dirname(__FILE__)}/../location/unlocode"

# TODO Move this into infrastructure specs file
  it "Cargo can be persisted" do
    hkg = Location.new(UnLocode.new('HKG'), 'Hong Kong')
    lgb = Location.new(UnLocode.new('LGB'), 'Long Beach')
    dal = Location.new(UnLocode.new('DAL'), 'Dallas')
    arrival_deadline = Date.new(2013, 7, 1)

    route_spec = RouteSpecification.new(hkg, lgb, arrival_deadline)
    cargo = Cargo.new(TrackingId.new('blah'), route_spec)

    CargoRepository.save(cargo)
  end
end
require 'rspec'
require 'date'
require "#{File.dirname(__FILE__)}/../cargo/cargo"
require "#{File.dirname(__FILE__)}/../cargo/leg"
require "#{File.dirname(__FILE__)}/../cargo/itinerary"
require "#{File.dirname(__FILE__)}/../cargo/tracking_id"
require "#{File.dirname(__FILE__)}/../cargo/route_specification"
require "#{File.dirname(__FILE__)}/../location/location"
require "#{File.dirname(__FILE__)}/../location/unlocode"

describe "Cargo" do

  it "should have a transport status of Not Received" do
    hkg = Location.new(UnLocode.new('HKG'), 'Hong Kong')
    lgb = Location.new(UnLocode.new('LGB'), 'Long Beach')
    arrival_deadline = Date.new(2013, 2, 3)
    route_spec = RouteSpecification.new(hkg, lgb, arrival_deadline)
    cargo = Cargo.new(TrackingId.new('blah'), route_spec)
    
    cargo.transport_status != true #:not_received
  end

  # TODO Make this test the correct thing
  it "Cargo is not considered unloaded at destination if there are no recorded handling events" do
     true
  end

  it "Cargo is not considered unloaded at destination after handling unload event but not at destination" do
    hkg = Location.new(UnLocode.new('HKG'), 'Hong Kong')
    lgb = Location.new(UnLocode.new('LGB'), 'Long Beach')
    dal = Location.new(UnLocode.new('DAL'), 'Dallas')
    arrival_deadline = Date.new(2013, 7, 1)
    
    route_spec = RouteSpecification.new(hkg, lgb, arrival_deadline)
    cargo = Cargo.new(TrackingId.new('blah'), route_spec)

    legs = Array.new
    legs << Leg.new(nil, hkg, Date.new(2013, 6, 14), lgb, Date.new(2013, 6, 18))
    legs << Leg.new(nil, lgb, Date.new(2013, 6, 19), dal, Date.new(2013, 6, 21))
    itinerary = Itinerary.new(legs)
    
    cargo.transport_status != true #:not_received
  end

  
end
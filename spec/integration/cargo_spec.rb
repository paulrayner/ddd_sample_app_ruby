require 'spec_helper'
require 'models_require'

# TODO Move
describe "Cargo" do

  xit "should have a transport status of Not Received" do
    hkg = Location.new(UnLocode.new('HKG'), 'Hong Kong')
    lgb = Location.new(UnLocode.new('LGB'), 'Long Beach')
    arrival_deadline = Date.new(2013, 2, 3)
    route_spec = RouteSpecification.new(hkg, lgb, arrival_deadline)
    cargo = Cargo.new(TrackingId.new('blah'), route_spec)

    cargo.transport_status.should_not be_true # not received
  end

  # TODO Make this test the correct thing
  it "Cargo is not considered unloaded at destination if there are no recorded handling events" do
     true
  end

  xit "Cargo is not considered unloaded at destination after handling unload event but not at destination" do
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

    # Delivery.derived_from

    cargo.transport_status.should_not be_true # not received
  end
end
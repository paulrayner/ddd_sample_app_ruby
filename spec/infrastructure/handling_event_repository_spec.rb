require 'spec_helper'
require 'models_require'
require 'handling_event_repository'

describe "HandlingEventRepository" do
  it "Handling event can be persisted" do
    handling_event_repository = HandlingEventRepository.new

    # TODO Replace this quick-and-dirty data teardown...
    # handling_event_repository.nuke_all_handling_events

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

    handling_event = HandlingEvent.new("Load", origin, Date.new(2013, 6, 14), Date.new(2013, 6, 15), cargo)

    handling_event_repository.save(handling_event)

    handling_event_history = handling_event_repository.lookup_handling_history_of_cargo(tracking_id)

    handling_event_history.count.should == 1
    handling_event = handling_event_history.first
    handling_event.tracking_id.should == 'cargo_1234'
    handling_event.location.should == origin
    handling_event.registration_date.should == Date.new(2013, 6, 14)
    handling_event.completion_date.should == Date.new(2013, 6, 15)
    handling_event.type.should == "Load"
  end
end
require 'spec_helper'
require 'models_require'
require 'cargo_repository'

describe "CargoRepository" do
  it "Cargo assigned to route but with no delivery history can be persisted" do
    cargo_repository = CargoRepository.new

    # TODO Replace this quick-and-dirty data teardown...
    cargo_repository.nuke_all_cargo

    origin = Location.new(UnLocode.new('HKG'), 'Hong Kong')
    destination = Location.new(UnLocode.new('DAL'), 'Dallas')
    arrival_deadline = DateTime.new(2013, 7, 1)

    route_spec = RouteSpecification.new(origin, destination, arrival_deadline)
    tracking_id = TrackingId.new('cargo_1234')
    port = Location.new(UnLocode.new('LGB'), 'Long Beach')
    legs = Array.new
    legs << Leg.new('Voyage ABC', origin, DateTime.new(2013, 6, 14), port, DateTime.new(2013, 6, 19))
    legs << Leg.new('Voyage DEF', port, DateTime.new(2013, 6, 21), destination, DateTime.new(2013, 6, 24))
    itinerary = Itinerary.new(legs)
    cargo = Cargo.new(tracking_id, route_spec)
    cargo.assign_to_route(itinerary)

    cargo_repository.store(cargo)

    found_cargo = cargo_repository.find_by_tracking_id(tracking_id)

    found_cargo.tracking_id.should == tracking_id
    found_cargo.route_specification.should == route_spec
    # TODO Get itinerary equality passing. Seems to be bombing on date comparison...UTC?
    # -  [Loading on voyage Voyage ABC in Hong Kong [HKG] on 2013-06-14, unloading in Hong Kong [HKG] on 2013-06-14,
    # -   Loading on voyage Voyage DEF in Long Beach [LGB] on 2013-06-21, unloading in Long Beach [LGB] on 2013-06-21]>
    # +  [Loading on voyage Voyage ABC in Hong Kong [HKG] on 2013-06-14 00:00:00 UTC, unloading in Hong Kong [HKG] on 2013-06-14 00:00:00 UTC,
    # +   Loading on voyage Voyage DEF in Long Beach [LGB] on 2013-06-21 00:00:00 UTC, unloading in Long Beach [LGB] on 2013-06-21 00:00:00 UTC]>
    #found_cargo.itinerary.should == itinerary

    # TODO create test that checks for these values in the actual MongoDB document. Since
    # all the values are calculated when Delivery is created, these tests don't mean much
    # right now
    # found_cargo.delivery.transport_status.should == "Not Received"
    # found_cargo.delivery.last_known_location.should be_nil
    # found_cargo.delivery.is_misdirected.should be_false
    # found_cargo.delivery.eta.should be_nil #== DateTime.new(2013, 6, 24)
    # found_cargo.delivery.is_unloaded_at_destination.should be_false
    # found_cargo.delivery.routing_status.should be_nil
    # found_cargo.delivery.calculated_at.should == "junk"
    # found_cargo.delivery.last_handled_event.should == "junk"
    # found_cargo.delivery.next_expected_activity.should == "junk"
  end

  it "Cargo with delivery history can be persisted" do
    cargo_repository = CargoRepository.new

    # TODO Replace this quick-and-dirty data teardown...
    cargo_repository.nuke_all_cargo

    origin = Location.new(UnLocode.new('HKG'), 'Hong Kong')
    destination = Location.new(UnLocode.new('DAL'), 'Dallas')
    arrival_deadline = DateTime.new(2013, 7, 1)

    route_spec = RouteSpecification.new(origin, destination, arrival_deadline)
    tracking_id = TrackingId.new('cargo_1234')
    port = Location.new(UnLocode.new('LGB'), 'Long Beach')
    legs = Array.new
    legs << Leg.new('Voyage ABC', origin, DateTime.new(2013, 6, 14), port, DateTime.new(2013, 6, 19))
    legs << Leg.new('Voyage DEF', port, DateTime.new(2013, 6, 21), destination, DateTime.new(2013, 6, 24))
    itinerary = Itinerary.new(legs)

    cargo = Cargo.new(tracking_id, route_spec)
    cargo.assign_to_route(itinerary)
    handling_event = HandlingEvent.new(HandlingEventType::Load, origin, DateTime.new(2013, 6, 14), DateTime.new(2013, 6, 15), tracking_id, HandlingEvent.new_id)
    handling_event_repository = HandlingEventRepository.new
    handling_event_repository.store(handling_event)
    cargo.derive_delivery_progress(handling_event)

    cargo_repository.store(cargo)

    found_cargo = cargo_repository.find_by_tracking_id(tracking_id)

    found_cargo.tracking_id.should == tracking_id
    found_cargo.route_specification.should == route_spec

    found_cargo.delivery.last_handling_event.id.should == handling_event.id
    found_cargo.delivery.transport_status.should == TransportStatus::OnboardCarrier
    found_cargo.delivery.last_known_location.should == origin
    found_cargo.delivery.is_misdirected.should be_false
    found_cargo.delivery.eta.should == DateTime.new(2013, 6, 24)
    found_cargo.delivery.is_unloaded_at_destination.should be_false
    found_cargo.delivery.routing_status.should == RoutingStatus::Routed
    # found_cargo.delivery.calculated_at.should == "junk" # TODO Need to fake the date
    found_cargo.delivery.last_handling_event.event_type.should == HandlingEventType::Load
    found_cargo.delivery.next_expected_activity.handling_event_type.should == HandlingEventType::Unload
    found_cargo.delivery.next_expected_activity.location.should == port
  end
end
require 'spec_helper'
require 'models_require'


def handling_event_fake(location, handling_event_type)
    registration_date = Date.new(2013, 6, 21)
    completion_date = Date.new(2013, 6, 21)

    # TODO How to set the enum to be UNLOADED?
    unloaded = HandlingEventType.new()
    # TODO Set it to fake tracking id for now
    HandlingEvent.new(handling_event_type, location, registration_date, completion_date, 999, HandlingEvent.new_id)
end

describe "Delivery" do
    before(:each) do
      @origin = Location.new(UnLocode.new('HKG'), 'Hong Kong')
      @destination = Location.new(UnLocode.new('DAL'), 'Dallas')
      arrival_deadline = Date.new(2013, 7, 1)
      @route_spec = RouteSpecification.new(@origin, @destination, arrival_deadline)

      @port = Location.new(UnLocode.new('LGB'), 'Long Beach')
      legs = Array.new
      legs << Leg.new('Voyage ABC', @origin, Date.new(2013, 6, 14), @port, Date.new(2013, 6, 19))
      legs << Leg.new('Voyage DEF', @port, Date.new(2013, 6, 21), @destination, Date.new(2013, 6, 24))
      @itinerary = Itinerary.new(legs)
    end

  it "Cargo is not considered unloaded at destination when there are no recorded handling events" do
    last_event = nil

    # TODO Implement derived_from once I work out static method, and calling constructor from
    # this static method (then delete the direct call to the constructor)
    delivery = Delivery.new(@route_spec, @itinerary, nil)
    # @delivery = @old_delivery.derived_from(@route_spec, itinerary, last_event);
    delivery.is_unloaded_at_destination.should be_false
  end

  it "Cargo is not considered unloaded at destination after handling unload event but not at destination" do
    delivery = Delivery.new(@route_spec, @itinerary, handling_event_fake(@port, "Unload"))
    delivery.is_unloaded_at_destination.should be_false
  end

  it "Cargo is not considered unloaded at destination after handling other event at destination" do
    delivery = Delivery.new(@route_spec, @itinerary, handling_event_fake(@destination, "Customs"))
    delivery.is_unloaded_at_destination.should be_false
  end

  it "Cargo is considered unloaded at destination after handling unload event at destination" do
    delivery = Delivery.new(@route_spec, @itinerary, handling_event_fake(@destination, "Unload"))
    delivery.is_unloaded_at_destination.should be_true
  end

  # TODO I really don't like the presence of nil here! Should have something like
  # an 'Unknown' location object rather than nil
  it "Cargo has unknown location when there are no recorded handling events" do
    delivery = Delivery.new(@route_spec, @itinerary, nil)
    delivery.last_known_location.should be_nil
  end

  it "Cargo has correct last known location based on most recent handling event" do
    delivery = Delivery.new(@route_spec, @itinerary, handling_event_fake(@destination, "Unload"))
    delivery.last_known_location.should == @destination
  end

  # TODO I really don't like the presence of nil here! Should have something like
  # an 'Unknown' location object rather than nil
  it "Cargo is not misdirected when there are no recorded handling events" do
    delivery = Delivery.new(@route_spec, @itinerary, nil)
    delivery.is_misdirected.should be_false
  end

  # TODO I really don't like the presence of nil here! Should have something like
  # an 'Unknown' itinerary object rather than nil
  it "Cargo is not misdirected when it has no itinerary" do
    delivery = Delivery.new(@route_spec, nil, handling_event_fake(@destination, "Unload"))
    delivery.is_misdirected.should be_false
  end

  it "Cargo is not misdirected when the last recorded handling event is a load in the origin which matches the itinerary" do
    delivery = Delivery.new(@route_spec, @itinerary, handling_event_fake(@origin, "Load"))
    delivery.is_misdirected.should be_false
  end

  it "Cargo is not misdirected when the last recorded handling event matches the itinerary" do
    delivery = Delivery.new(@route_spec, @itinerary, handling_event_fake(@destination, "Unload"))
    delivery.is_misdirected.should be_false
  end

  it "Cargo is misdirected when the last recorded handling event does not match the itinerary" do
    delivery = Delivery.new(@route_spec, @itinerary, handling_event_fake(@destination, "Load"))
    delivery.is_misdirected.should be_true
  end

  it "Cargo is not routed when it doesn't have an itinerary" do
    delivery = Delivery.new(@route_spec, nil, handling_event_fake(@destination, "Load"))
    delivery.routing_status.should == RoutingStatus::NotRouted
  end

  it "Cargo is routed when specification is satisfied by itinerary" do
    delivery = Delivery.new(@route_spec, @itinerary, handling_event_fake(@destination, "Load"))
    delivery.routing_status.should == RoutingStatus::Routed
  end

  it "Cargo is on track when the cargo has been routed and is not misdirected" do
    delivery = Delivery.new(@route_spec, @itinerary, handling_event_fake(@destination, "Unload"))
    delivery.on_track?.should be_true
  end

  it "Cargo is not on track when the cargo has been routed and is misdirected" do
    delivery = Delivery.new(@route_spec, @itinerary, handling_event_fake(@destination, "Load"))
    delivery.on_track?.should be_false
  end

  it "Cargo transport status is not received when there are no recorded handling events" do
    delivery = Delivery.new(@route_spec, @itinerary, nil)
    delivery.transport_status.should == TransportStatus::NotReceived
  end

  it "Cargo transport status is in port when the last recorded handling event is an unload" do
    delivery = Delivery.new(@route_spec, @itinerary, handling_event_fake(@destination, "Unload"))
    delivery.transport_status.should == TransportStatus::InPort
  end

  it "Cargo transport status is in port when the last recorded handling event is a receive" do
    delivery = Delivery.new(@route_spec, @itinerary, handling_event_fake(@destination, "Receive"))
    delivery.transport_status.should == TransportStatus::InPort
  end

  it "Cargo transport status is onboard carrier when the last recorded handling event is a load" do
    delivery = Delivery.new(@route_spec, @itinerary, handling_event_fake(@destination, "Load"))
    delivery.transport_status.should == TransportStatus::OnboardCarrier
  end

  it "Cargo transport status is claimed when the last recorded handling event is a claim" do
    delivery = Delivery.new(@route_spec, @itinerary, handling_event_fake(@destination, "Claim"))
    delivery.transport_status.should == TransportStatus::Claimed
  end

  it "Cargo has correct eta based on itinerary when on track" do
    delivery = Delivery.new(@route_spec, @itinerary, handling_event_fake(@origin, "Load"))
    delivery.eta.should == @itinerary.final_arrival_date
  end

  it "Cargo has no eta when not on track" do
    delivery = Delivery.new(@route_spec, @itinerary, handling_event_fake(@origin, "Unload"))
    delivery.eta.should be_nil
  end

  it "Cargo has no next expected activity when not on track" do
    delivery = Delivery.new(@route_spec, @itinerary, handling_event_fake(@origin, "Unload"))
    delivery.next_expected_activity.should be_nil
  end

  # TODO Change the following to use Enum for HandlingEventType rather than strings
  it "Cargo has next expected activity of receive at origin when there are no recorded handling events" do
    delivery = Delivery.new(@route_spec, @itinerary, nil)
    delivery.next_expected_activity.should == HandlingActivity.new("Receive", @origin)
  end

  it "Cargo has next expected activity of load at origin when when the last recorded handling event is a receive" do
    delivery = Delivery.new(@route_spec, @itinerary, handling_event_fake(@origin, "Receive"))
    delivery.next_expected_activity.should == HandlingActivity.new("Load", @origin)
  end

  it "Cargo has next expected activity of unload at next port when the last recorded handling event is a load at origin" do
    delivery = Delivery.new(@route_spec, @itinerary, handling_event_fake(@origin, "Load"))
    delivery.next_expected_activity.should == HandlingActivity.new("Unload", @port)
  end

  it "Cargo has next expected activity of load at port when the last recorded handling event is an unload at the port" do
    delivery = Delivery.new(@route_spec, @itinerary, handling_event_fake(@port, "Unload"))
    delivery.next_expected_activity.should == HandlingActivity.new("Load", @port)
  end

  it "Cargo has next expected activity of unload at destination when the last recorded handling event is a load at the previous port" do
    delivery = Delivery.new(@route_spec, @itinerary, handling_event_fake(@port, "Load"))
    delivery.next_expected_activity.should == HandlingActivity.new("Unload", @destination)
  end

  it "Cargo has next expected activity of claim at destination when the last recorded handling event is an unload at the destination" do
    delivery = Delivery.new(@route_spec, @itinerary, handling_event_fake(@destination, "Unload"))
    delivery.next_expected_activity.should == HandlingActivity.new("Claim", @destination)
  end
end

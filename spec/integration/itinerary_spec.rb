require 'spec_helper'
require 'models_require'


def handling_event_fake(location, handling_event_type)
    registration_date = Date.new(2013, 6, 21)
    completion_date = Date.new(2013, 6, 21)

    # TODO How to set the enum to be UNLOADED?
    unloaded = HandlingEventType.new()
    # TODO How is it possible to have a HandlingEvent with a nil Cargo?
    #unload_handling_event = HandlingEvent.new(unloaded, @port, registration_date, completion_date, nil)
    HandlingEvent.new(handling_event_type, location, registration_date, completion_date, nil)
end

# TODO Implement itinerary specs - probably need to be renamed to fit rspec idiom
describe "Itinerary" do

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

  # TODO .NET version does var cargoWithEmptyItinerary = new Itinerary(new Leg[] { });
  # How is this even a valid Itinerary? How can an Itinerary be "empty"? In other
  # words, if an Itinerary by definition is an ordered set of Legs, how is the notion
  # of an empty Itinerary even coherent? The Java version throws an exception for an
  # empty Itinerary.
  # it "Claim event is not expected by an empty itinerary" do
  # end

  it "Receive event is expected when first leg load location matches event location" do
    @itinerary.is_expected(handling_event_fake(@origin, "Receive")).should be_true
  end

  it "Receive event is not expected when first leg load location doesn't match event location" do
    @itinerary.is_expected(handling_event_fake(@port, "Receive")).should be_false
  end

  it "Claim event is expected when last leg unload location matches event location" do
    @itinerary.is_expected(handling_event_fake(@destination, "Claim")).should be_true
  end

  it "Claim event is not expected when last leg unload location doesnt match event location" do
    @itinerary.is_expected(handling_event_fake(@port, "Claim")).should be_false
  end

  it "Load event is expected when first leg load location matches event location" do
    @itinerary.is_expected(handling_event_fake(@origin, "Load")).should be_true
  end

  it "Load event is expected when second leg load location matches event location" do
    @itinerary.is_expected(handling_event_fake(@port, "Load")).should be_true
  end

  it "Load event is not expected when event location doesn't match any legs load location" do
    @itinerary.is_expected(handling_event_fake(@destination, "Load")).should be_false
  end

  it "Unload event is expected when first leg unload location matches event location" do
    @itinerary.is_expected(handling_event_fake(@port, "Unload")).should be_true
  end

  it "Unload event is expected when second leg unload location matches event location" do
    @itinerary.is_expected(handling_event_fake(@destination, "Unload")).should be_true
  end

  it "Unload event is not expected when event location doesn't match any legs unload location" do
    @itinerary.is_expected(handling_event_fake(@origin, "Unload")).should be_false
  end
end

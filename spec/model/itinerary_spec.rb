require 'rspec'
require 'date'
require 'pp'
# TODO Improve the way model requires are working
require "#{File.dirname(__FILE__)}/../../model/cargo/cargo"
require "#{File.dirname(__FILE__)}/../../model/cargo/leg"
require "#{File.dirname(__FILE__)}/../../model/cargo/itinerary"
require "#{File.dirname(__FILE__)}/../../model/cargo/tracking_id"
require "#{File.dirname(__FILE__)}/../../model/cargo/route_specification"
require "#{File.dirname(__FILE__)}/../../model/location/location"
require "#{File.dirname(__FILE__)}/../../model/location/unlocode"
require "#{File.dirname(__FILE__)}/../../model/handling/handling_event"
require "#{File.dirname(__FILE__)}/../../model/handling/handling_event_type"

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
    @itinerary.is_expected(handling_event_fake(@origin, "Load")).should == true
  end

  it "Receive event is not expected when first leg load location doesn't match event location" do
    @itinerary.is_expected(handling_event_fake(@port, "Receive")).should == false
  end

  # it "Claim event is expected when last leg unload location matches event location" do
  # end

  # it "Claim event is not expected when last leg unload location doesnt match event location" do
  # end

  # it "Load event is expected when first leg load location matches event location" do
  # end

  # it "Load event is expected when second leg load location matches event location" do
  # end

  # it "Load event is not expected when event location doesnt match any legs load location" do
  # end

  # it "Unload event is expected when first leg unload location matches event location" do
  # end

  # it "Unload event is expected when second leg unload location matches event location" do
  # end

  # it "Load event is not expected when event location doesnt match any legs unload location" do
  # end
end

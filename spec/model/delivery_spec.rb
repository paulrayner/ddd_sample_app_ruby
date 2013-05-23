require 'spec_helper'
require 'rspec'
require 'date'

# TODO Improve the way model requires are working
require "#{File.dirname(__FILE__)}/../../model/cargo/cargo"
require "#{File.dirname(__FILE__)}/../../model/cargo/delivery"
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

# TODO Implement delivery specs
describe "Delivery" do
    before(:each) do
      origin = Location.new(UnLocode.new('HKG'), 'Hong Kong')
      @destination = Location.new(UnLocode.new('DAL'), 'Dallas')
      arrival_deadline = Date.new(2013, 7, 1)
      @route_spec = RouteSpecification.new(origin, @destination, arrival_deadline)

      @port = Location.new(UnLocode.new('LGB'), 'Long Beach')
      legs = Array.new
      legs << Leg.new('Voyage ABC', origin, Date.new(2013, 6, 14), @port, Date.new(2013, 6, 19))
      legs << Leg.new('Voyage DEF', @port, Date.new(2013, 6, 21), @destination, Date.new(2013, 6, 24))
      @itinerary = Itinerary.new(legs)
    end

  it "Cargo is not considered unloaded at destination if there are no recorded handling events" do
    last_event = nil

    # TODO Implement derived_from once I work out static method, and calling constructor from 
    # this static method (then delete the direct call to the constructor)
    delivery = Delivery.new(@route_spec, @itinerary, nil)
    # @delivery = @old_delivery.derived_from(@route_spec, itinerary, last_event);
    delivery.is_unloaded_at_destination.should == false
  end

  it "Cargo is not considered unloaded at destination after handling unload event but not at destination" do
    registration_date = Date.new(2013, 6, 21)
    completion_date = Date.new(2013, 6, 21)

    delivery = Delivery.new(@route_spec, @itinerary, handling_event_fake(@port, "Unload"))
    delivery.is_unloaded_at_destination.should == false
  end

  it "Cargo is not considered unloaded at destination after handling other event at destination" do
    registration_date = Date.new(2013, 6, 21)
    completion_date = Date.new(2013, 6, 21)

    # TODO How to set the enum to be UNLOADED?
    unloaded = HandlingEventType.new()
    # TODO How is it possible to have a HandlingEvent with a nil Cargo?
    #unload_handling_event = HandlingEvent.new(unloaded, @port, registration_date, completion_date, nil)
    unload_handling_event = HandlingEvent.new("Customs", @port, registration_date, completion_date, nil)
    delivery = Delivery.new(@route_spec, @itinerary, unload_handling_event)
    delivery.is_unloaded_at_destination.should == false
  end

  it "Cargo is considered unloaded at destination after handling unload event at destination" do
    registration_date = Date.new(2013, 6, 21)
    completion_date = Date.new(2013, 6, 21)

    # TODO How to set the enum to be UNLOADED?
    unloaded = HandlingEventType.new()
    # TODO How is it possible to have a HandlingEvent with a nil Cargo?
    #unload_handling_event = HandlingEvent.new(unloaded, @port, registration_date, completion_date, nil)
    unload_handling_event = HandlingEvent.new("Unload", @destination, registration_date, completion_date, nil)
    delivery = Delivery.new(@route_spec, @itinerary, unload_handling_event)
    delivery.is_unloaded_at_destination.should == true
  end

  it "Delivery has correct last known location based on handling event" do
    delivery = Delivery.new(@route_spec, @itinerary, handling_event_fake(@destination, "Unload"))
    delivery.last_known_location.should == @destination
  end
end
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

# TODO Implement delivery specs
describe "Delivery" do
  it "Cargo is not considered unloaded at destination if there are no recorded handling events" do
    origin = Location.new(UnLocode.new('HKG'), 'Hong Kong')
    destination = Location.new(UnLocode.new('DAL'), 'Dallas')
    arrival_deadline = Date.new(2013, 7, 1)
    route_spec = RouteSpecification.new(origin, destination, arrival_deadline)

    port = Location.new(UnLocode.new('LGB'), 'Long Beach')
    legs = Array.new
    legs << Leg.new('Voyage ABC', origin, Date.new(2013, 6, 14), port, Date.new(2013, 6, 19))
    legs << Leg.new('Voyage DEF', port, Date.new(2013, 6, 21), destination, Date.new(2013, 6, 24))
    itinerary = Itinerary.new(legs)

    last_event = nil

    @delivery = Delivery.new(nil, itinerary, route_spec)
    # @delivery = @old_delivery.derived_from(route_spec, itinerary, last_event);
    puts @delivery.inspect
    @delivery.is_unloaded_at_destination.should == false
  end

  # it "Cargo is not considered unloaded at destination after handling unload event but not at destination" do
  #   false.should == true
  # end

  # it "Cargo is not considered unloaded at destination after handling other event at destination" do
  #   false.should == true
  # end

  # it "Cargo is considered unloaded at destination after handling unload event at destination" do
  #   false.should == true
  # end
end
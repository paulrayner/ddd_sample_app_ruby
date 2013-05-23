require 'spec_helper'
require 'rspec'
require 'date'

# TODO Improve the way model requires are working
require "#{File.dirname(__FILE__)}/../../model/cargo/cargo"
require "#{File.dirname(__FILE__)}/../../model/cargo/leg"
require "#{File.dirname(__FILE__)}/../../model/cargo/itinerary"
require "#{File.dirname(__FILE__)}/../../model/cargo/tracking_id"
require "#{File.dirname(__FILE__)}/../../model/cargo/route_specification"
require "#{File.dirname(__FILE__)}/../../model/location/location"
require "#{File.dirname(__FILE__)}/../../model/location/unlocode"

# TODO Implement delivery specs
describe "Delivery" do
  it "Cargo is not considered unloaded at destination if there are no recorded handling events" do
    false.should == true
  end

  it "Cargo is not considered unloaded at destination after handling unload event but not at destination" do
    false.should == true
  end

  it "Cargo is not considered unloaded at destination after handling other event at destination" do
    false.should == true
  end

  it "Cargo is considered unloaded at destination after handling unload event at destination" do
    false.should == true
  end
end
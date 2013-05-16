require 'rspec'
require 'date'
# TODO Improve the way model requires are working
require "#{File.dirname(__FILE__)}/../cargo/cargo"
require "#{File.dirname(__FILE__)}/../cargo/leg"
require "#{File.dirname(__FILE__)}/../cargo/itinerary"
require "#{File.dirname(__FILE__)}/../cargo/tracking_id"
require "#{File.dirname(__FILE__)}/../cargo/route_specification"
require "#{File.dirname(__FILE__)}/../cargo/cargo_repository"

require "#{File.dirname(__FILE__)}/../location/location"
require "#{File.dirname(__FILE__)}/../location/unlocode"

# TODO Implement itinerary specs - probably need to be renamed to fit rspec idiom
describe "Itinerary" do

  it "Claim event is not expected by an empty itinerary" do
  end

  it "Receive event is expected when first leg load location matches event location" do
  end

  it "Receive event is not expected when first leg load location doesnt match event location" do
  end

  it "Claim event is expected when last leg unload location matches event location" do
  end

  it "Claim event is not expected when last leg unload location doesnt match event location" do
  end

  it "Load event is expected when first leg load location matches event location" do
  end

  it "Load event is expected when second leg load location matches event location" do
  end

  it "Load event is not expected when event location doesnt match any legs load location" do
  end

  it "Unload event is expected when first leg unload location matches event location" do
  end

  it "Unload event is expected when second leg unload location matches event location" do
  end

  it "Load event is not expected when event location doesnt match any legs unload location" do
  end
end

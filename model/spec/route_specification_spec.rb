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

  # TODO Implement route specification specs
describe "RouteSpecification" do

  it "is satisfied if origin and destination match and deadline is not exceeded" do
  end

  it "is not satisfied if arrival deadline is exceeded" do
  end

  it "is not satisfied if origin does not match" do
  end

  it "is not satisfied if destination does not match" do
  end
end
require 'rspec'
require 'date'
require "#{File.dirname(__FILE__)}/../cargo/cargo"
require "#{File.dirname(__FILE__)}/../cargo/tracking_id"
require "#{File.dirname(__FILE__)}/../cargo/route_specification"
require "#{File.dirname(__FILE__)}/../location/location"
require "#{File.dirname(__FILE__)}/../location/unlocode"

describe "Cargo" do

  it "should have a transport status of Not Received" do
    hkg = Location.new(UnLocode.new('HKG'), 'Hong Kong')
    lgb = Location.new(UnLocode.new('LGB'), 'Long Beach')
    arrival_deadline = Date.new(2013, 2, 3)
    route_spec = RouteSpecification.new(hkg, lgb, arrival_deadline)
    cargo = Cargo.new(TrackingId.new('blah'), route_spec)
    
    cargo.transport_status != true #:not_received
  end
end
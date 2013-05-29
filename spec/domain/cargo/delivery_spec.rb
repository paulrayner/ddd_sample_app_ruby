require 'spec_helper'
require 'delivery'

# defining delivery here means this unit test is not dependent upon the actual Delivery class
class HandlingActivity < Struct.new(:one, :two); end

# def initialize(route_specification, itinerary, last_handled_event)
describe Delivery do
  before do
    DateTime.stub(:now).and_return('123')
  end

  context "initialize()" do
    it "should raise an error if route_specification is nil" do
      expect {
        Delivery.new(nil, 'something', 'something')
        }.to raise_error(Delivery::InitializationError)
    end

    it "should raise an error if itinerary is nil" do
      expect {
        Delivery.new('something', nil, 'something')
        }.to raise_error(Delivery::InitializationError)
    end

    it "should not raise an error if last_handled_event is nil" do
      route = double("route_specification", :is_satisfied_by => 'Routed', :origin => 'something')
      itinerary = double("itinerary", :final_arrival_date => DateTime.now)
      expect {
        Delivery.new(route, itinerary, nil)
        }.to_not raise_error
    end


  end # context initialize()


  context "derived_from()" do

  end # context derived_from()

  context "calculate_last_known_location()" do


  end # context calculate_last_known_location()

  context "calculate_unloaded_at_destination()" do


  end # context calculate_unloaded_at_destination()

  context "calculate_misdirection_status()" do

  end # context calculate_misdirection_status()


  context "on_track?()" do

  end # context on_track?()


  context "calculate_routing_status()" do

  end # context calculate_routing_status()


  context "calculate_transport_status()" do

  end # context calculate_transport_status()


  context "calculate_eta()" do

  end # context calculate_eta()

  context "calculate_next_expected_activity()" do

  end # context calculate_next_expected_activity()

  context "comparison ( == )" do
    it "should be the same as another delivery object if the attributes are the same" do
      # one = Delivery.new(:x, :y, :z)
    end
  end # context comparison


end
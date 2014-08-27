require 'spec_helper'
require 'cargo'
require 'delivery'

# # this doesn't work when running with all specs
# class Delivery < Struct.new(:one, :two, :three); end

# reopen Delivery to allow stubbing (otherwise it's frozen)
# class Delivery
#   def initialize(route_specification='x', itinerary=nil, last_handled_event=nil); end
# end


describe Cargo do

  context "initialize()" do
    it "should raise an error if no tracking_id passed in" do
      expect {
        Cargo.new(nil, 'something')
        }.to raise_error(Cargo::InitializationError)
    end

    it "should raise an error if no route_specification passed in" do
      expect {
        Cargo.new('something', nil)
        }.to raise_error(Cargo::InitializationError)
    end

    it "should not raise an error if a tracking_id and route_specification are passed in" do
      expect {
        Cargo.new('something', 'something')
        }.to_not raise_error
    end

    it "should create a delivery object" do
      Delivery.stub(:new
        ).and_return('something')
      cargo = Cargo.new('something', 'something')
      cargo.delivery.should_not be_nil
      cargo.delivery.should == 'something'
    end
  end # context initialize()


  context "entity equality" do
    it "should equal a cargo with the same tracking id" do
      @cargo = Cargo.new(TrackingId.new('999'), 'fake route')
      @cargo.should == Cargo.new(TrackingId.new('999'), 'another fake route')
    end

    it "should not equal a cargo with a different cargo number" do
      @cargo = Cargo.new(TrackingId.new('999'), 'fake route')
      @cargo.should_not == Cargo.new(TrackingId.new('555'), 'fake route')
    end
  end

  context "specify_new_route()" do
    before do
      @cargo = Cargo.new('tracking', 'route')
      @delivery = @cargo.delivery
      @cargo.specify_new_route('new_route')
    end

    it "should update the route_specification with the passed in value" do
      @cargo.route_specification.should == 'new_route'
    end

    it "should update the delivery object" do
      @cargo.delivery.should_not == @delivery
    end
  end # context specify_new_route()

  context "assign_to_route()" do
    before do
      @cargo = Cargo.new('tracking', 'route')
      @itinerary = @cargo.itinerary
      @cargo.assign_to_route('new_itinerary')
    end

    it "should update the itinerary with the passed in value" do
      @cargo.itinerary.should == 'new_itinerary'
    end

    it "should have a different itinerary" do
      @cargo.itinerary.should_not == @itinerary
    end
  end # context assign_to_route()

  context "derive_delivery_progress()" do
    before do
      Delivery.stub(:new).and_return(double('delivery', :last_handling_event => 'last_event'))
      @cargo = Cargo.new('tracking', 'route')
      @delivery = @cargo.delivery
      # stub it again to have it return a different double
      Delivery.stub(:new).and_return(double('delivery', :last_handling_event => 'last_event'))
      @cargo.derive_delivery_progress('last_event')
    end

    it "should have a delivery" do
      @cargo.delivery.should_not be_nil
    end

    it "should be a different delivery" do
      @cargo.delivery.should_not == @delivery
    end

  end # context derive_delivery_progress()

  context "checking that Delivery value objects are created" do
    it "should create new Delivery on cargo initialization" do
      Delivery.should_receive(:new)
      Cargo.new('tracking', 'route')
    end

    it "should create new Delivery on specify_new_route" do
      cargo = Cargo.new('tracking', 'route')
      Delivery.should_receive(:new)
      cargo.specify_new_route('something')
    end

    it "should create new Delivery on derive_delivery_progress" do
      cargo = Cargo.new('tracking', 'route')
      Delivery.should_receive(:new)
      cargo.derive_delivery_progress('something')
    end

    it "should not create new Delivery on assign_to_route" do
      cargo = Cargo.new('tracking', 'route')
      Delivery.should_not_receive(:new)
      cargo.assign_to_route('something')
    end
  end # context checking Delivery object creation
end
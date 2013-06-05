require 'spec_helper'
require 'delivery_generator'
require 'delivery'

class HandlingActivity < Struct.new(:handling_event_type, :location); end

describe DeliveryGenerator do

  # ===========  generate  ===========
  context "generate()" do
    it "should raise an error if route_specification is nil" do
      expect {
        DeliveryGenerator.generate(nil, 'something', 'something')
      }.to raise_error(Delivery::InitializationError)
    end

    it "should not raise an error if last_handled_event is nil" do
      expect {
        DeliveryGenerator.generate(stub.as_null_object, 'something', nil)
      }.to_not raise_error
    end
  end # context initialize()


  # ===========  calculate_last_known_location  ===========
  context "calculate_last_known_location()" do

    it "should return nil if last_handled_event is nil" do
      DeliveryGenerator.calculate_last_known_location(nil).should be_nil
    end

    it "should return the location if last_handled_event is not nil" do
      fake_last_handled_event = double(:location => 'a_location')
      DeliveryGenerator.calculate_last_known_location(fake_last_handled_event).should == 'a_location'
    end
  end # context calculate_last_known_location()

  # ===========  calculate_unloaded_at_destination  ===========
  context "calculate_unloaded_at_destination()" do

    it "should return false if last_handled_event is nil" do
      DeliveryGenerator.calculate_unloaded_at_destination(nil, 'something').should be_false
    end

    it "should return true if event_type is Unload AND location is the destination" do
      fake_last_handled_event = double('last_handled_event', location:'a_location', event_type:'Unload')
      fake_route_specification = double('route_specification', destination:'a_location')
      DeliveryGenerator.calculate_unloaded_at_destination(fake_last_handled_event, fake_route_specification).should be_true
    end

    it "should return false if event_type is not Unload" do
      fake_last_handled_event = double('last_handled_event', event_type:'something')
      fake_route_specification = double('route_specification')
      DeliveryGenerator.calculate_unloaded_at_destination(fake_last_handled_event, fake_route_specification).should be_false
    end

    it "should return false if location doesn't equal destination" do
      fake_last_handled_event = double('last_handled_event', location:'a_location', event_type:'Unload')
      fake_route_specification = double('route_specification', destination:'another_location')
      DeliveryGenerator.calculate_unloaded_at_destination(fake_last_handled_event, fake_route_specification).should be_false
    end
  end # context calculate_unloaded_at_destination()

  # ===========  calculate_misdirection_status  ===========
  context "calculate_misdirection_status()" do

    it "should return false if last_handled_event is nil" do
      DeliveryGenerator.calculate_misdirection_status('something', nil).should be_false
    end

    it "should return false if itinerary is nil" do
      DeliveryGenerator.calculate_misdirection_status(nil,'something').should be_false
    end

    it "should return true if is_expected() returns false" do
      fake_last_handled_event = double('last_handled_event')
      fake_itinerary = double('itinerary', is_expected:false)
      DeliveryGenerator.calculate_misdirection_status(fake_last_handled_event, fake_itinerary).should be_true
    end

    it "should return false if is_expected() returns true" do
      fake_last_handled_event = double('last_handled_event')
      fake_itinerary = double('itinerary', is_expected:true)
      DeliveryGenerator.calculate_misdirection_status(fake_last_handled_event, fake_itinerary).should be_false
    end
  end # context calculate_misdirection_status()

  # ===========  on_track?  ===========
  context "on_track?()" do

    it "should return true if routing_status is Routed and misdirected is false" do
      DeliveryGenerator.instance_variable_set(:@routing_status, 'Routed')
      DeliveryGenerator.stub(:is_misdirected).and_return(false)
      DeliveryGenerator.on_track?.should be_true
    end

    it "should return false if routing_status is not Routed" do
      DeliveryGenerator.instance_variable_set(:@routing_status, 'something')
      DeliveryGenerator.on_track?.should be_false
    end

    it "should return false if is_misdirected is not false" do
      DeliveryGenerator.instance_variable_set(:@routing_status, 'Routed')
      DeliveryGenerator.stub(:is_misdirected).and_return(true)
      DeliveryGenerator.on_track?.should be_false
    end
  end # context on_track?()

  # ===========  calculate_routing_status  ===========
  context "calculate_routing_status()" do

    it "should return nil if itinerary is nil" do
      DeliveryGenerator.calculate_routing_status(nil, 'something').should be_nil
    end

    it "should return Routed if route specification is satisfied by the itinerary" do
      fake_route_specification = double('route_specification', is_satisfied_by:true)
      DeliveryGenerator.calculate_routing_status('something', fake_route_specification).should == 'Routed'
    end

    it "should return Misrouted if route specification is not satisfied by the itinerary" do
      fake_route_specification = double('route_specification', is_satisfied_by:false)
      DeliveryGenerator.calculate_routing_status('something', fake_route_specification).should == 'Misrouted'
    end
  end # context calculate_routing_status()

  # ===========  calculate_transport_status  ===========
  context "calculate_transport_status()" do

    it "should return 'Not Received' if last_handled_event is nil" do
      DeliveryGenerator.calculate_transport_status(nil).should == 'Not Received'
    end

    {'Load' => 'Onboard Carrier', 'Unload' => 'In Port', 'Receive' => 'In Port', 'Claim' => 'Claimed',
      'Something' => 'Unknown', nil => 'Unknown'}.each do |event_type, event_display|
      it "should show #{event_display} when last_handled_event is of type #{event_type}" do
        fake_last_handled_event = double('last_handled_event', event_type:event_type)
        fake_last_handled_event.should_receive(:event_type)
        DeliveryGenerator.calculate_transport_status(fake_last_handled_event).should == event_display
      end
    end
  end # context calculate_transport_status()

  # ===========  calculate_eta  ===========
  context "calculate_eta()" do

    it "should return nil if not on track" do
      DeliveryGenerator.stub(:on_track?).and_return(false)
      DeliveryGenerator.calculate_eta('something').should be_nil
    end

    it "should return the final_arrival_date on itinerary if on track" do
      DeliveryGenerator.stub(:on_track?).and_return(true)
      fake_itinerary = double('itinerary', final_arrival_date:'today')
      DeliveryGenerator.calculate_eta(fake_itinerary).should == 'today'
    end
  end # context calculate_eta()

  # ===========  calculate_next_expected_activity  ===========
  context "calculate_next_expected_activity()" do
    before do
      DeliveryGenerator.stub(:on_track?).and_return(true)
    end

    it "should return nil if not on track" do
      DeliveryGenerator.stub(:on_track?).and_return(false)
      DeliveryGenerator.calculate_next_expected_activity('something', 'something', 'something').should be_nil
    end

    # this could be split into a context and three checks: class, param one, and param two
    it "should return a 'Receive' HandlingActivity if last_handled_event is nil" do
      fake_route_specification = double('route_specification', origin:'an_origin')
      return_value = DeliveryGenerator.calculate_next_expected_activity(nil, fake_route_specification, 'something')
      return_value.should be_a_kind_of(HandlingActivity)
      return_value.handling_event_type.should  == 'Receive'
      return_value.location.should == 'an_origin'
    end

    it "should return a 'Load' HandlingActivity if last_handled_event is 'Receive'" do
      fake_last_handled_event = double('last_handled_event', event_type:'Receive')
      fake_itinerary = double('itinerary')
      fake_itinerary.stub_chain(:legs,:first,:load_location).and_return('a_location')
      return_value = DeliveryGenerator.calculate_next_expected_activity(fake_last_handled_event, 'something', fake_itinerary)
      return_value.should be_a_kind_of(HandlingActivity)
      return_value.handling_event_type.should  == 'Load'
      return_value.location.should == 'a_location'
    end

    it "should return an 'Unload' HandlingActivity if last_handled_event is 'Load' and last_leg_index is not nil" do
      fake_last_handled_event = double('last_handled_event', event_type:'Load', location:'a_location')
      fake_legs = [double(load_location:'a_location', unload_location:'an_unload_location')]
      fake_itinerary = double('itinerary', legs:fake_legs)
      return_value = DeliveryGenerator.calculate_next_expected_activity(fake_last_handled_event, 'something', fake_itinerary)
      return_value.should be_a_kind_of(HandlingActivity)
      return_value.handling_event_type.should  == 'Unload'
      return_value.location.should == 'an_unload_location'
    end

    it "should return nil if last_handled_event is 'Load' and last_leg_index is nil" do
      fake_last_handled_event = double('last_handled_event', event_type:'Load', location:'an_unknown_location')
      fake_legs = [double(load_location:'a_location', unload_location:'an_unload_location')]
      fake_itinerary = double('itinerary', legs:fake_legs)
      DeliveryGenerator.calculate_next_expected_activity(fake_last_handled_event, 'something', fake_itinerary).should be_nil
    end

    it "should return nil if last_handled_event is 'Unload' and there is no leg that matches the last_handled_event" do
      fake_last_handled_event = double('last_handled_event', event_type:'Unload', location:'an_unknown_location')
      fake_legs = 4.times.collect { |c| double("leg#{c}", load_location:"load_at_#{c}", unload_location:"unload_at_#{c}") }
      fake_itinerary = double('itinerary', legs:fake_legs)
      DeliveryGenerator.calculate_next_expected_activity(fake_last_handled_event, 'something', fake_itinerary).should be_nil
    end

    it "should return a 'Load' HandlingActivity if last_handled_event is 'Unload' and locations match and there is no next_leg" do
      fake_last_handled_event = double('last_handled_event', event_type:'Unload', location:'unload_at_2')
      fake_legs = 3.times.collect { |c| double("leg#{c}", load_location:"load_at_#{c}", unload_location:"unload_at_#{c}") }
      fake_legs << nil # set next_leg to be nil
      fake_itinerary = double('itinerary', legs:fake_legs)
      return_value = DeliveryGenerator.calculate_next_expected_activity(fake_last_handled_event, 'something', fake_itinerary)
      return_value.should be_a_kind_of(HandlingActivity)
      return_value.handling_event_type.should  == 'Load'
      return_value.location.should == 'load_at_2'
    end

    it "should return a 'Claim' HandlingActivity if last_handled_event is 'Unload' and locations match and there is a next_leg" do
      fake_last_handled_event = double('last_handled_event', event_type:'Unload', location:'unload_at_2')
      fake_legs = 4.times.collect { |c| double("leg#{c}", load_location:"load_at_#{c}", unload_location:"unload_at_#{c}") }
      fake_itinerary = double('itinerary', legs:fake_legs)
      return_value = DeliveryGenerator.calculate_next_expected_activity(fake_last_handled_event, 'something', fake_itinerary)
      return_value.should be_a_kind_of(HandlingActivity)
      return_value.handling_event_type.should  == 'Claim'
      return_value.location.should == 'unload_at_2'
    end

    it "should return nil if last_handled_event is 'Claim'" do
      fake_last_handled_event = double('last_handled_event', event_type:'Claim')
      DeliveryGenerator.calculate_next_expected_activity(fake_last_handled_event, 'something', 'something').should be_nil
    end

    it "should return nil if last_handled_event is anything else" do
      fake_last_handled_event = double('last_handled_event', event_type:'something')
      DeliveryGenerator.calculate_next_expected_activity(fake_last_handled_event, 'something', 'something').should be_nil
    end
  end # context calculate_next_expected_activity()




end
